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
- options menu with Easy, Medium and Hard difficulty
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
- Easy mode minimap/radar showing the player, collectables and portal
- Medium mode as the standard/classic version of the game
- Hard mode where collectables reset after death
- moving platforms
- breakable platforms that reset after respawn
- parallax background
- tutorial text prompts in level 1
- basic player animations: idle, run, jump, fall, and wall slide
- run dust particles for movement feedback
- jump sound with small random pitch variation
- collectable sound with small random pitch variation
- looping background music during gameplay
- simple lighting polish with directional light and point lights
- GUT tests for some core systems such as timer, death counter, difficulty and collectable reset

## Controls

```text
Move left  - A / Left Arrow
Move right - D / Right Arrow
Jump       - Space
Pause      - Esc
```

## Difficulty Modes

```text
Easy
- shows a minimap/radar in the top right
- minimap shows player position, collectables and portal
- collectables stay collected after death

Medium
- standard version of the prototype
- no minimap
- collectables stay collected after death

Hard
- no minimap
- collectables reset after death
- mistakes are more punishing
```

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
test/            GUT automated tests
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

## Testing

The prototype was tested using a mixture of manual testing, black box playtesting, regression testing and some automated GUT tests.

The automated tests focus on systems where the expected result is clear, such as:

- timer reset and timer running
- death counter increasing
- large death count values
- difficulty mode helpers
- collectable pickup and reset behaviour
- basic level structure checks

Manual testing and playtesting were used for movement feel, difficulty, hazards, portal logic, pause, audio, minimap, and full game flow.

During playtesting, five people tried the current prototype and none of them managed to complete the full game flow except me. This showed that the core game loop works, but the current difficulty is still too high for most new players. It also showed that the tutorial and difficulty curve need more work in future versions.

## Known Limitations

This is a prototype, so the focus is on the core platforming loop rather than full game polish.

Current limitations:

- keyboard controls only
- no save system
- no level select system
- options menu is limited to difficulty only
- visual style still uses some prototype and placeholder assets
- some sprites/visuals were generated or inspired using AI tools and then edited or adapted for this academic prototype
- the project is not intended for commercial release
- future development should replace all temporary/prototype visuals with fully original handmade assets
- difficulty needs more balancing after wider playtesting
- the three levels feel more like examples from different stages of a bigger game rather than one smooth difficulty curve
- tutorial text helps the current prototype, but future versions should teach mechanics more naturally through level design
- audio and visual feedback are simple and not final quality

## Credits / Assets

This project uses a mixture of self-made, edited, free/placeholder and AI-assisted prototype assets.

Some visual assets were generated or inspired using AI tools and then edited or adapted for use in the prototype. These assets are used only for a university project and not for commercial purposes. If the project was developed further, the visual style would need a full original art pass with all final sprites created or properly licensed.

Asset use and design references are documented in the supporting project documentation.
