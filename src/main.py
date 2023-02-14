import minedojo

env = minedojo.make(task_id="harvest_milk", image_size=(160, 256))
obs = env.reset()
done = False
while not done:
    action = env.action_space.no_op()    # 8-len vector
    obs, reward, done, info = env.step(actions)
    
