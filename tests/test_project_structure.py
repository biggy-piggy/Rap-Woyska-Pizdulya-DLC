from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


class ProjectStructureTest(unittest.TestCase):
    def test_first_playable_slice_files_exist(self):
        expected_files = [
            "scenes/Main.tscn",
            "scenes/Player.tscn",
            "scripts/arena.gd",
            "scripts/game_manager.gd",
            "scripts/player.gd",
        ]

        missing = [path for path in expected_files if not (ROOT / path).is_file()]

        self.assertEqual(missing, [])

    def test_project_starts_from_main_scene(self):
        project = read("project.godot")

        self.assertIn('run/main_scene="res://scenes/Main.tscn"', project)

    def test_parking_arena_contains_canonical_m5_details(self):
        arena = read("scripts/arena.gd")

        self.assertIn("covered parking", arena)
        self.assertIn("BMW M5", arena)
        self.assertIn("open hood", arena)
        self.assertIn("oil puddle", arena)

    def test_ui_contains_project_canon_phrases(self):
        main_scene = read("scenes/Main.tscn")

        self.assertIn("Rap Woyska (Pizdulya DLC)", main_scene)
        self.assertIn("Choose your dolboyob", main_scene)
        self.assertIn("Press F to receive pizdulya", main_scene)
        self.assertIn("Friendship ended. Hitbox started.", main_scene)


if __name__ == "__main__":
    unittest.main()
