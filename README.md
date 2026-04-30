# Abyss of the Loss

A 2D psychological horror/mystery game built with **Godot Engine** and **GDScript**.

---

## About

*Abyss of the Loss* represents a mysterious and haunting realm that symbolizes both physical darkness and inner despair. The word "Abyss" evokes a vast, endless void — an unknown place filled with danger, secrets, and forgotten souls. "The Lost" refers to those who have vanished: beings, memories, or fragments of humanity trapped between existence and oblivion.

### Story

The game follows a young man who suddenly loses his loyal dog, **Doby**, while walking through a dark forest. Desperate and confused, Noah searches every corner of the woods until he stumbles upon an abandoned house — a place that seems to call to him.

Inside, Noah discovers strange clues and hidden puzzles that appear to lead to Doby's whereabouts. Each mystery he solves pulls him deeper into the house's secrets, and deeper into his own mind. But when Noah reaches the final puzzle, he's faced with a truth he never expected — one that shatters his perception of reality and forces him to confront the darkness within himself.

### Main Character 

he suffers from **Dissociative Identity Disorder (DID)**, with two contrasting identities living within him (overlapping with traits of Bipolar Personality Disorder):

- **The Gentle Self** — Kind, selfless, and empathetic. The last trace of his humanity.
- **The Dark Self** — Cold, unpredictable, and psychotic. Born from pain and buried memories.

At first, Noah has no idea about the existence of his second self.

---

## Features

- **Animated player character** — idle and walk sprite animations
- **Animal companions** — a cat (idle, walk, run animations) and a dog
- **Multiple environments** — house scene and forest scenes with parallax/background art
- **Interactive objects** — doors with area detection, openable closets
- **Lighting system** — dynamic light/dark background states
- **HUD/UI layer** — canvas layer overlay for interface elements

---

## Project Structure

```
Apyss_of_the_loss_final/
├── player.gd / player.tscn       # Player character logic and scene
├── cat.gd / cat.tscn             # Cat companion logic and scene
├── dog.gd / doging.tscn          # Dog companion logic and scene
├── house.gd / house.tscn         # House environment
├── world.gd / world.tscn         # Main world/overworld scene
├── control.gd / control.tscn     # Game control / menu scene
├── canvas_layer.gd               # HUD and UI overlay
├── DoorArea.gd / door_area.gd    # Door interaction logic
├── export_presets.cfg            # Godot export configurations
├── project.godot                 # Godot project settings
└── .github/workflows/            # CI/CD workflows
```

**Assets:** Sprite sheets and backgrounds for the player, cat, dog, forest, house interiors, closet states (open/closed), and lighting variants (light/dark).

---

## Requirements

- [Godot Engine 4.x](https://godotengine.org/download) (the project uses `.uid` files and other conventions introduced in Godot 4)

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/khalilAmustafa/Apyss_of_the_loss_final.git
   ```

2. **Open in Godot**
   - Launch Godot Engine
   - Click **Import** and select the `project.godot` file from the cloned folder

3. **Run the game**
   - Press **F5** or click the **Play** button to start from the main scene

---

## Controls

> *(Update this section with the actual in-game controls)*

| Action | Key |
|--------|-----|
| Move   | Arrow keys / WASD |
| Interact | E / Space |

---

## Built With

- [Godot 4](https://godotengine.org/) — Game engine
- GDScript — Scripting language (100% of codebase)

---

## Author

**khalilAmustafa** — [GitHub](https://github.com/khalilAmustafa)

---

## License

This project does not currently specify a license. All rights reserved by the author unless otherwise stated.
