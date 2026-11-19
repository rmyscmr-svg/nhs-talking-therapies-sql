"""Make the two charts used in the README (needs pandas and matplotlib)."""
import matplotlib
import pandas as pd

matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Chart 1: waiting times against the 75% standard
w = pd.read_csv("results/03_waiting_times_vs_standard.csv")
w["m"] = pd.to_datetime(w.month).dt.strftime("%b %y")
fig, ax = plt.subplots(figsize=(9, 4.5))
ax.plot(w.m, w.within_6_weeks_pct, marker="o", color="#1f6fb2", lw=2.2, label="Started within 6 weeks")
ax.axhline(75, color="#c0392b", ls="--", lw=1.5, label="NHS standard (75%)")
ax.set_ylim(70, 95)
ax.set_ylabel("% of people finishing treatment")
ax.set_title("England: share starting treatment within 6 weeks of referral", loc="left", fontsize=12)
ax.legend(frameon=False)
ax.spines[["top", "right"]].set_visible(False)
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("images/waiting_times_6_weeks.png", dpi=100)

# Chart 2: recovery rate by region against the 50% ambition
r = pd.read_csv("results/04_recovery_by_region.csv").sort_values("avg_recovery_pct")
names = r.region.str.title().str.replace(" And ", " and ").str.replace(" Of ", " of ")
fig, ax = plt.subplots(figsize=(9, 4.5))
colours = ["#c0392b" if v < 50 else "#1f6fb2" for v in r.avg_recovery_pct]
ax.hlines(names, 40, r.avg_recovery_pct, color="#cccccc", lw=2)
ax.scatter(r.avg_recovery_pct, names, color=colours, s=90, zorder=3)
ax.axvline(50, color="black", ls="--", lw=1.2)
for y, v in enumerate(r.avg_recovery_pct):
    ax.text(v + 0.25, y, f"{v}%", va="center", fontsize=9)
ax.set_xlim(40, 53)
ax.set_xlabel("Average recovery rate (%), Aug 2025 – Aug 2026")
ax.set_title("Recovery rate by NHS region (dashed line = 50% ambition, red = below)", loc="left", fontsize=12)
ax.spines[["top", "right"]].set_visible(False)
plt.tight_layout()
plt.savefig("images/recovery_by_region.png", dpi=100)
print("Charts saved in images/")
