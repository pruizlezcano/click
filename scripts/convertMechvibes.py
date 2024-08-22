import argparse
import json
import os
from pathlib import Path

key_code_relation = {
    "1": "53",  # Esc
    "59": "122",  # F1
    "60": "120",  # F2
    "61": "99",  # F3
    "62": "118",  # F4
    "63": "96",  # F5
    "64": "97",  # F6
    "65": "98",  # F7
    "66": "100",  # F8
    "67": "101",  # F9
    "68": "109",  # F10
    "87": "103",  # F11
    "88": "111",  # F12
    "91": "105",  # F13
    "92": "107",  # F14
    "93": "113",  # F15
    "94": "106",  # F16
    "95": "64",  # F17
    "96": "79",  # F18
    "97": "80",  # F19
    "41": "50",  # ` (Grave)
    "2": "18",  # 1
    "3": "19",  # 2
    "4": "20",  # 3
    "5": "21",  # 4
    "6": "23",  # 5
    "7": "22",  # 6
    "8": "26",  # 7
    "9": "28",  # 8
    "10": "25",  # 9
    "11": "29",  # 0
    "12": "27",  # -
    "13": "24",  # =
    "14": "51",  # Backspace
    "15": "48",  # Tab
    "58": "57",  # CapsLock
    "30": "0",  # A
    "48": "11",  # B
    "46": "8",  # C
    "32": "2",  # D
    "18": "14",  # E
    "33": "3",  # F
    "34": "5",  # G
    "35": "4",  # H
    "23": "34",  # I
    "36": "38",  # J
    "37": "40",  # K
    "38": "37",  # L
    "50": "46",  # M
    "49": "45",  # N
    "24": "31",  # O
    "25": "35",  # P
    "16": "12",  # Q
    "19": "15",  # R
    "31": "1",  # S
    "20": "17",  # T
    "22": "32",  # U
    "47": "9",  # V
    "17": "13",  # W
    "45": "7",  # X
    "21": "16",  # Y
    "44": "6",  # Z
    "26": "33",  # [
    "27": "30",  # ]
    "43": "42",  # \
    "39": "41",  # ;
    "40": "39",  # '
    "28": "36",  # Enter
    "51": "43",  # ,
    "52": "47",  # .
    "53": "44",  # /
    "57": "49",  # Space
    "3639": "105",  # PrtSc (F13 typically)
    "70": "107",  # ScrLk (F14 typically)
    "3653": "113",  # Pause (F15 typically)
    "3666": "114",  # Insert (macOS often doesn't have a direct equivalent)
    "3667": "117",  # Delete
    "3655": "115",  # Home
    "3663": "119",  # End
    "3657": "116",  # PgUp
    "3665": "121",  # PgDn
    "57416": "126",  # ↑
    "57419": "123",  # ←
    "57421": "124",  # →
    "57424": "125",  # ↓
    "42": "56",  # Left Shift
    "54": "60",  # Right Shift
    "29": "59",  # Left Ctrl
    "3613": "62",  # Right Ctrl
    "56": "58",  # Left Alt (Option)
    "3640": "61",  # Right Alt (Option)
    "3675": "55",  # Left Command
    "3676": "54",  # Right Command
    "3677": "110",  # Menu (might map to macOS "Contextual Menu" key or no direct equivalent)
    "69": "71",  # Num Lock (Clear)
    "3637": "75",  # Numpad /
    "55": "67",  # Numpad *
    "74": "78",  # Numpad -
    "3597": "81",  # Numpad = (not always available on all keyboards)
    "78": "69",  # Numpad +
    "3612": "76",  # Numpad Enter
    "83": "65",  # Numpad .
    "79": "83",  # Numpad 1
    "80": "84",  # Numpad 2
    "81": "85",  # Numpad 3
    "75": "86",  # Numpad 4
    "76": "87",  # Numpad 5
    "77": "88",  # Numpad 6
    "71": "89",  # Numpad 7
    "72": "91",  # Numpad 8
    "73": "92",  # Numpad 9
    "82": "82",  # Numpad 0
    "28": "36",  # Return (already mapped, but correctly placed here too)
    "56": "58",  # Option (Left Alt)
    "69": "71",  # Clear (Num Lock / Clear)
    "3640": "61",  # Option (Right Alt)
    "3666": "63",  # Fn (often no direct equivalent keycode)
    "3675": "55",  # Command (Left Command)
    "3676": "54",  # Command (Right Command)
}


def convert_mechvibes(input_file: Path, output_file: Path):
    # check file exists
    if not os.path.exists(input_file):
        raise FileNotFoundError(f"Input file '{input_file}' does not exist.")

    with input_file.open("r") as file:
        try:
            data = json.load(file)
        except json.JSONDecodeError as e:
            raise ValueError(f"Error decoding JSON: {e}")

    # check if the json is a mechvibes soundpack
    if not all(
        key in data
        for key in ["name", "key_define_type", "includes_numpad", "defines", "tags"]
    ):
        raise ValueError("Not a Mechvibes soundpack: Missing required keys.")

    # replace the keycodes
    new_defines = {}
    for keyCode, sounds in data["defines"].items():
        new_keyCode = key_code_relation.get(keyCode)
        if new_keyCode:
            new_defines[new_keyCode] = sounds

    data["defines"] = new_defines
    data.pop("id", None)
    data.pop("default", None)
    data.pop("sound", None)

    with open(output_file, "w") as file:
        json.dump(data, file, indent=2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Convert Mechvibes soundpack to a Click soundpack"
    )
    parser.add_argument("input_file", type=Path, help="The input file to be converted")
    parser.add_argument(
        "output_file", type=Path, help="The output file to be written to"
    )

    args = parser.parse_args()
    try:
        convert_mechvibes(args.input_file, args.output_file)
    except Exception as e:
        print(f"Error: {e}")
