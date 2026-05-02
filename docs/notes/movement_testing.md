# Movement Testing Notes

## Current Movement Features

- horizontal movement
- jump
- jump buffer
- coyote time
- wall slide
- wall jump
- wall coyote time

## Current Tuning Values

- move_speed: 256.0
- horizontal_acceleration: 2048.0
- horizontal_friction: 4096.0
- gravity_strength: 512.0
- max_fall_speed: 512.0
- jump_velocity: -200.0
- jump_buffer_time: 0.15
- coyote_time: 0.10
- wall_coyote_time: 0.10 / tested higher values

Jump buffer was added because the first version of the prototype required the player to press jump at the exact frame of landing. This felt too strict and made movement less fair. A short jump buffer gives the player a small timing window, so the jump still feels responsive without making the level easier in a major way

Coyote time was added to make edge jumps feel more fair. Without it, the player loses the ability to jump instantly after leaving a platform, even if visually it still feels like they were close enough to jump. A short coyote window makes the controls feel more forgiving

Wall slide was added to support more interesting level layouts. The player can use walls to control falling and prepare for a wall jump. The slide is not infinite, because I do not want the player to sit on one wall forever

Wall coyote time gives the player a short chance to wall jump after losing contact with a wall. During testing this created an interesting movement feel, because it almost works like a small air jump, but only after interacting with a wall.

The movement already feels more responsive than the first basic prototype. Jump buffer and coyote time make ground jumps feel more fair, while wall slide and wall jump make the level design more interesting.

The next systems should focus on turning the movement prototype into a playable game loop:

1. fall death
2. respawn
3. spike hazards
4. collectables
5. level exit / portal
6. animations through the state machine
