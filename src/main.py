import gym
import minerl



def main():

    env = gym.make('MineRLBasaltFindCave-v0')
    obs = env.reset()
    done = False
    net_reward = 0

    while not done:
        action = env.action_space.noop()

        action['back'] = 0
        action['forward'] = 1
        action['jump'] = 1
        action['attack'] = 1

        obs, reward, done, info = env.step(
            action)

        net_reward += reward
        print("Total reward: ", net_reward)
        env.render()
 
if __name__ == "__main__":
    main()
