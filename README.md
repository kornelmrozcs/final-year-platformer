# finalYearPlatformer

A 2D pixel platformer prototype made in Godot for my final year university project.

The project focuses on responsive movement, difficult but fair level design, hazards, collectables, death and respawn, basic animations, and three playable levels with increasing difficulty.

## Project Overview

finalYearPlatformer is a short skill-based platformer where the main challenge comes from movement and level mastery rather than combat or story.

The player has to move through dangerous levels, avoid hazards, collect all required collectables, and reach the portal at the end of each stage. The game is designed around learning through failure, quick respawns, and repeated attempts.

The current prototype includes a full flow from the main menu through three levels and into a results screen.

```text
Main Menu -> Level 1 -> Level 2 -> Level 3 -> Results Screen
```

## Current Features

- simple main menu
- pause menu with resume and quit
- three playable levels
- responsive player controller
- air control
- coyote time
- jump buffering
- wall slide
- wall jump
- death and respawn system
- respawn fade
- hazards such as spikes, deadly surfaces, water/fall death, and moving saws
- collectables required before the portal opens
- portal progression between levels
- HUD with collectable count, death counter, and timer
- final results screen showing run time and deaths
- moving platforms
- breakable platforms that reset after respawn
- parallax background
- basic player animations: idle, run, jump, fall, and wall slide
- simple sound and feedback for some interactions

## Controls

Move left - A/Left Arrow
Move right - D/Right Arrow
Jump - Space
Pause - Esc

## How to Play

Start the game from the main menu and select **Start Game**.

Each level has collectables and a portal. The portal only opens after all required collectables in the level have been picked up.

Hazards kill the player on contact and send the player back to the level spawn point. The death counter increases after each normal death, and the timer tracks the full run.

## How to Run the Build

Build is for Windows.
Keep the generated build files in the same folder:

```text
finalYearPlatformer.exe
finalYearPlatformer.pck
```

Run:

```text
finalYearPlatformer.exe
```

If the game does not start, make sure the zip was fully extracted first and that the `.exe` and `.pck` files are still together in the same folder.

## How to Open the Source Project

1. Install Godot 4.x.
2. Open Godot Project Manager.
3. Click **Import**.
4. Select the `project.godot` file from the project folder.
5. Open the project.
6. Press Play to run the game.

The current main scene is:

```text
res://scenes/ui/main_menu.tscn
```

## Main Project Structure

```text
assets/          sprites, audio and imported game assets
docs/            project notes, testing notes and media
scenes/          Godot scenes for levels, UI, player, hazards and objects
scripts/         GDScript files for gameplay, UI and systems
project.godot    main Godot project file
```

## Development Tools

- Godot Engine
- GDScript
- Visual Studio Code
- GitHub
- Miro
- Canva
- Affinity

## Known Limitations

This is a prototype, so the focus is on the core platforming loop rather than full game polish.

Current limitations:

- keyboard controls only
- no save system
- no level select system
- no full settings/options menu
- visual style still uses some prototype and placeholder assets
- difficulty need more balancing after wider playtesting
- audio and visual feedback are simple and not final quality

## Credits / Assets

This project uses a mixture of self-made, edited, and free/placeholder assets for prototyping.
Asset use and design references are documented in the supporting project documentation.
