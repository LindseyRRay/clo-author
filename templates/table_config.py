import pandas as pd

TABLE_FMT = ".2F"


def _fmt(x, fmt=".1f"):
    """Format a number, returning '--' for NaN."""
    if pd.isna(x):
        return "--"
    return f"{x:{fmt}}"


def fmt(x: float, dec: int = 1) -> str:
    """Format a number with *dec* decimal places, returning '--' for NaN."""
    if pd.isna(x):
        return "--"
    return f"{x:.{dec}f}"


def fmt_sd(x: float, dec: int = 1) -> str:
    """Format a standard deviation in parentheses."""
    if pd.isna(x):
        return "--"
    return f"({x:.{dec}f})"


def fmt_pct(x: float) -> str:
    """Format a proportion as a percentage (e.g. 0.635 -> '63.5%')."""
    if pd.isna(x):
        return "--"
    return f"{x:.1%}"


def fmt_int(x: int) -> str:
    """Format an integer with comma separators."""
    if pd.isna(x):
        return "--"
    return f"{int(x):,}"
