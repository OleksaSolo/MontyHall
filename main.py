import random
def monty_hall_simulation(num_trials=10000, switch=True):
    wins = 0
    for _ in range(num_trials):
        doors = [0, 0, 1]  # 1 - prize, 0 - empty doors
        random.shuffle(doors)
        choice = random.randint(0, 2)  # Player randomly chooses a door
        # Host opens one of the empty doors
        available_doors = [i for i in range(3) if i != choice and doors[i] == 0]
        host_opens = random.choice(available_doors)
        if switch:
            # Player switches to the other closed door
            choice = next(i for i in range(3) if i != choice and i != host_opens)
        if doors[choice] == 1:
            wins += 1
    return wins / num_trials
# Run simulation
def main():
    num_trials = 10000
    win_rate_switch = monty_hall_simulation(num_trials, switch=True)
    win_rate_stay = monty_hall_simulation(num_trials, switch=False)
    print(f"Winning probability when switching: {win_rate_switch:.4f}")
    print(f"Winning probability when staying: {win_rate_stay:.4f}")

if __name__ == "__main__":
    main()

