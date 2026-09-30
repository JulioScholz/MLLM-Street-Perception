from pathlib import Path

import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data"


def main() -> None:
    data = pd.read_csv(
        DATA_DIR / "SPECS" / "labels" / "processed" / "global_mapped_cleaned_with_ahiremapped.csv",
        index_col=0,
    )
    img_data = pd.read_csv(DATA_DIR / "SPECS" / "svi" / "metadata.csv", index_col=0)
    img_paths = pd.read_csv(DATA_DIR / "SPECS" / "svi" / "img_paths.csv", index_col=0)

    images = img_data.merge(
        img_paths,
        on="uuid",
        how="left",
    )

    images = images.rename(columns={
        "Image number": "image_id",
        "Relabelled Name": "image_name",
    })

    images["path"] = images["path"].str.replace(
        "data/svi/",
        "data/SPECS/svi/",
        regex=False,
    )

    data = data.merge(
        images.add_prefix("left_"),
        left_on="Left_image",
        right_on="left_image_id",
        how="left",
    )

    data = data.merge(
        images.add_prefix("right_"),
        left_on="Right_image",
        right_on="right_image_id",
        how="left",
    )

    data[data.Question == "safe"].to_csv(DATA_DIR / "specs_data_safe.csv")


if __name__ == "__main__":
    main()
