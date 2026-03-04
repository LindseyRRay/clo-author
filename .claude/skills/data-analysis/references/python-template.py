"""
[Descriptive Title]

Purpose: [What this script does]
Inputs: [Data files from config.py]
Outputs: [Figures, tables, parquet files]
"""

import datetime

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statsmodels.api as sm

import config

try:
    import figure_settings
    figure_settings.apply_style("paper")
except ImportError:
    pass

# Setup
np.random.seed(42)

TODAY = datetime.date.today().isoformat()
FIGURES_DIR = config.DATA_PATH / "Output" / "Figures" / TODAY
TABLES_DIR = config.DATA_PATH / "Output" / "Tables" / TODAY
FIGURES_DIR.mkdir(parents=True, exist_ok=True)
TABLES_DIR.mkdir(parents=True, exist_ok=True)

# 1. Data Loading
df = pd.read_parquet(config.WORKING_DATA_PATH / "panel.parquet")

# 2. Summary Statistics

# 3. Main Analysis

# 4. Tables and Figures

# 5. Export
