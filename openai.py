import pygame

# Initialize pygame
pygame.init()

# Set up the window
win = pygame.display.set_mode((800, 600))
pygame.display.set_caption("Pong")

# Define colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)

# Define game objects
paddle_1 = pygame.Rect(20, 250, 20, 100)
paddle_2 = pygame.Rect(760, 250, 20, 100)
ball = pygame.Rect(400, 300, 20, 20)

# Define movement variables
paddle_1_speed = 0
paddle_2_speed = 0
ball_speed_x = 5
ball_speed_y = 5

# Define game loop
running = True
while running:
    # Process events
    for event in pygame.event.get():
        # Check if the user has quit the game
        if event.type == pygame.QUIT:
            running = False

        # Check if the user has pressed a key
        if event.type == pygame.KEYDOWN:
            # Check which key was pressed and adjust the movement variables accordingly
            if event.key == pygame.K_w:
                paddle_1_speed = -5
            if event.key == pygame.K_s:
                paddle_1_speed = 5
            if event.key == pygame.K_UP:
                paddle_2_speed = -5
            if event.key == pygame.K_DOWN:
                paddle_2_speed = 5

        # Check if the user has released a key
        if event.type == pygame.KEYUP:
            # Check which key was released and adjust the movement variables accordingly
            if event.key == pygame.K_w:
                paddle_1_speed = 0
            if event.key == pygame.K_s:
                paddle_1_speed = 0
            if event.key == pygame.K_UP:
                paddle_2_speed = 0
            if event.key == pygame.K_DOWN:
                paddle_2_speed = 0

    # Update game objects
    paddle_1.y += paddle_1_speed
    paddle_2.y += paddle_2_speed
    ball.x += ball_speed_x
    ball.y += ball_speed_y

    # Check if the ball has hit the top or bottom of the screen and adjust the movement accordingly
    if ball.y < 0 or ball.y > 580:
        ball_speed_y = -ball_speed_y

    # Check if the ball has hit a paddle and adjust the movement accordingly
    if ball.colliderect(paddle_1) or ball.colliderect(paddle_2):
        ball_speed_x = -ball_speed_x

    # Draw game objects
    win.fill(BLACK)
    pygame.draw.rect(win, WHITE, paddle_1)
    pygame.draw.rect(win, WHITE, paddle_2)
    pygame.draw.rect(win, WHITE, ball)
    pygame.display
