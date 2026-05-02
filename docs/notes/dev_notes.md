# Development Notes

## First Step

I added the first test scene and a basic tilemap level. The idea for this test level is that it should eventually require all planned movement features to complete it.

So far, I added:

- basic player movement
- jump
- tilemap collision
- player collision
- camera follow
- first test level layout
- placeholder/free sprites
- edited player colour
- extra wall slide frame in the player sprite sheet for later use

After testing, the movement already feels quite responsive in the air, and I like that the character feels fast. However, it is still very rough. The jump currently has to be pressed almost perfectly when the player touches the ground, because there is no jump buffer yet. There is also no coyote time, so falling from platforms feels unforgiving and harder to control. The jump height also feels too high at the moment.

Next movement improvements:

- add jump buffer
- add coyote time
- tune jump height
- improve falling control
- start preparing the controller for a simple state machine

## Added Basic Player State Machine

After the first movement test, I started restructuring the player controller into a simple state machine. The reason for this is that movement is the most important part of this project, so I want the controller to stay readable as more movement features are added.

The current state machine is still basic. It only handles:

- Idle
- Run
- Jump
- Fall

The player controller still keeps the shared movement values and helper functions, such as speed, gravity, jump force, horizontal movement and input checks. The state machine decides which movement state is currently active and calls the correct logic from that state.

## Fall Death and Respawn Test

I added the first fall death and respawn loop. The player is now added to the global `player` group, and the fall death trigger checks for this group before calling the respawn logic.

The FallDeath object is currently made as a scene. It uses an `Area2D` with a `CollisionShape2D`, and the shape is currently a `WorldBoundaryShape2D` instead of a rectangle collision shape. This works well for a simple fall boundary because it acts like a long/infinite boundary line, so it is easy to place under the level.

Current behaviour:

- player falls below the level
- FallDeath detects the player
- respawn state starts
- player movement is disabled during respawn
- player returns to the respawn position

This now gives the prototype a basic fail and retry loop.

## Current Design Problem

The fall death works, but the player cannot clearly see where the death boundary starts. This could feel unfair because the player only learns the limit after dying.

This is readability / UX problem. The level should communicate danger clearly before the player touches it. If the player cannot tell where the dangerous area begins, the death can feel unfair instead of fair.

This connects to general usability principles where the player should receive clear feedback about what is happening and what the state of the system is. In games, this also means using clear visual language so the player can quickly understand what is safe, what is dangerous, and what can be interacted with.

## Ideas?

### Option 1 - Add a visible death layer

Add a visible layer at the bottom of the level, such as dark water, lava, fog, spikes, or a void effect. This would make it clear that falling into that area means death.

This is probably the best first solution because it is simple and easy to understand.

The death area could change depending on the style of the level:

- water for an icy/cold level
- lava or fire for a dangerous cave level
- dark fog/void for a monochrome abstract level
- spikes for a more classic platformer style

This would make the levels feel more different while still using the same respawn code.

### Option 2 - Add warning tiles before the death area

Add visual warning tiles near the bottom of platforms. For example, broken edges, darker tiles, warning lines, or small particles moving upward from the death zone.

This would help the player understand that the area below is dangerous without needing a full lava/water sprite.

### Option 3 - Add camera or colour grading feedback

The lower part of the level could have a darker colour grade or slight background change. This would show the player that they are entering a dangerous zone.

### Option 4 - Add audio/visual feedback when falling too low

The game could play a warning sound or show a small visual effect when the player gets close to the death zone. This might help, but it is less direct than simply showing a clear hazard area.

## Decision

add a visible hazard layer

# Water Notes

## Current Purpose

The water is currently used as a visual feedback object, not as the main death system

The player still dies through the FallDeath area. Water only reacts visually when the player enters it. This keeps the respawn logic separate from the water effect, which makes the system easier to reuse later.

## Why Water Is Separate From FallDeath

Water is a reusable scene. It can be used under the level as a death area visual, but it could also be used later as decoration or as a different type of hazard.

FallDeath only has one job:

- detect when the player has fallen out of the playable area
- request respawn

Water has a different job:

- detect when the player enters the water
- create a splash / visual reaction
- later play a splash sound
