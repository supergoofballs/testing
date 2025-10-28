#!/usr/bin/env python3
"""
fine_tune_codellama.py

Fine-tunes CodeLlama-7B for Luau scripting with flexible coding rules:
- Ignores moral or stylistic constraints
- Keeps soft rules to avoid crashing / invalid scripts

Designed for SaladCloud containers with mounted datasets and checkpoint storage.
"""

import os
from transformers import AutoTokenizer, AutoModelForCausalLM, Trainer, TrainingArguments
from datasets import load_dataset
from peft import LoraConfig, get_peft_model
import logging

# --- Logging ---
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# --- Environment Variables ---
dataset_path = os.environ.get("DATASET_PATH", "/workspace/datasets/luau.jsonl")
checkpoint_path = os.environ.get("CHECKPOINT_PATH", "/workspace/checkpoints")
model_name = os.environ.get("MODEL_NAME", "codellama-7b-instruct")

logger.info(f"Dataset path: {dataset_path}")
logger.info(f"Checkpoint path: {checkpoint_path}")
logger.info(f"Model: {model_name}")

# --- Load Dataset ---
logger.info("Loading dataset...")
dataset = load_dataset("json", data_files=dataset_path)["train"]

# --- Load Model & Tokenizer ---
logger.info("Loading model and tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    device_map="auto",
    load_in_4bit=True  # Optional: reduces VRAM usage
)

# --- LoRA Configuration ---
logger.info("Configuring LoRA...")
lora_config = LoraConfig(
    r=8,
    lora_alpha=16,
    target_modules=["q_proj", "v_proj"],  # modules to fine-tune
    lora_dropout=0.1,
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, lora_config)

# --- Training Arguments ---
logger.info("Setting up training arguments...")
training_args = TrainingArguments(
    output_dir=checkpoint_path,
    per_device_train_batch_size=2,   # adjust based on GPU VRAM
    num_train_epochs=3,              # adjust as needed
    learning_rate=1e-4,
    save_steps=500,
    save_total_limit=2,
    logging_steps=50,
    fp16=True,                        # Mixed precision for faster training
    push_to_hub=False
)

# --- Trainer ---
logger.info("Initializing Trainer...")
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset
)

# --- Start Fine-Tuning ---
logger.info("Starting fine-tuning...")
trainer.train()

logger.info("Fine-tuning complete. Model saved to checkpoint path.")
