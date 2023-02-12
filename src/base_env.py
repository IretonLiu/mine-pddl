from minerl.herobraine.hero.mc import MS_PER_STEP, STEPS_PER_MS
from minerl.herobraine.env_specs.simple_embodiment import SimpleEmbodimentEnvSpec
from minerl.herobraine.hero.handler import Handler
import sys
from typing import List
import numpy as np
from goal_location import get_goal_location

import minerl.herobraine
import minerl.herobraine.hero.handlers as handlers

NAVIGATE_STEPS = 1000000


class TestEnv(SimpleEmbodimentEnvSpec):

    def __init__(self, *args,
                video_resolution=(600, 600),
                 guiscale_range=[1, 1],
                 gamma_range=[2.0, 2.0],
                 fov_range=[90.0, 90.0],
                 cursor_size_range=[16, 16],
                **kwargs):
        name = 'Nic-v0'

        self.video_resolution = video_resolution
        self.guiscale_range = guiscale_range
        self.gamma_range = gamma_range
        self.fov_range = fov_range
        self.cursor_size_range = cursor_size_range
        super().__init__(name, *args, max_episode_steps=100, **kwargs)

    def is_from_folder(self, folder: str) -> bool:
        return folder == 'Nics'

    def create_observables(self) -> List[Handler]:
        return super().create_observables() + [
            handlers.CompassObservation(angle=True, distance=True),
            handlers.ObservationFromCurrentLocation(),
            handlers.FlatInventoryObservation(['diamond_block'])
            
            ]

    def create_actionables(self) -> List[Handler]:
        return super().create_actionables() + [
            handlers.PlaceBlock(['none', 'diamond_block'],_other='none', _default='none'),
            handlers.ChatAction(),
            ]

    def create_rewardables(self) -> List[Handler]:
        return [
                #    handlers.RewardForTouchingBlockType([
                #        {'type': 'diamond_block', 'behaviour': 'onceOnly',
                #         'reward': 500.0},
                #    ])
                # ([handlers.RewardForDistanceTraveledToCompassTarget(
                #     reward_per_block=1.0
                #     )])+
                handlers.RewardForCollectingItemsOnce([
                    dict(type="diamond_block", amount=1, reward=20.0),
                    ])
               ] 

    def create_agent_start(self) -> List[Handler]:
        return [
            # handlers.SimpleInventoryAgentStart([
            #     dict(type='compass', quantity='1')
            # ]),
            handlers.AgentStartPlacement(0,4,0,0,0)
        ]

    def create_agent_handlers(self) -> List[Handler]:
        return [
            # handlers.AgentQuitFromTouchingBlockType(
            #     ["diamond_block"]
            # )
        ]

    def create_server_world_generators(self) -> List[Handler]:
        gl = get_goal_location()
        return [
            # handlers.DefaultWorldGenerator(force_reset=True)
            handlers.FlatWorldGenerator(generatorString="1;7,2x3,2;1"),
            handlers.DrawingDecorator(
                #'<DrawCuboid x1="'+str(gl[0])+'" y1="1" z1="'+str(gl[1])+'" x2="'+str(gl[0])+'" y2="6" z2="'+str(gl[1])+'" type="diamond_block"/>'
                 '<DrawCuboid x1="6" y1="4" z1="0" x2="6" y2="4" z2="0" type="diamond_block"/>'+
                 '<DrawCuboid x1="-6" y1="3" z1="0" x2="-6" y2="3" z2="0" type="gold_block"/>'
        #  """
        #      <DrawCuboid x1="-6" y1="6" z1="0" x2="-12" y2="6" z2="0" type="gold_block"/>
        #      <DrawCuboid x1="6" y1="6" z1="0" x2="12" y2="6" z2="0" type="redstone_block"/>
        #      <DrawCuboid x1="0" y1="6" z1="-6" x2="0" y2="6" z2="-12" type="iron_block"/>
        #  """
         )
        ]

    def create_server_quit_producers(self) -> List[Handler]:
        return [
            handlers.ServerQuitFromTimeUp(NAVIGATE_STEPS*MS_PER_STEP),
            # handlers.ServerQuitWhenAnyAgentFinishes()
        ]

    def create_server_decorators(self) -> List[Handler]:
        return [
            # handlers.NavigationDecorator(
            # max_randomized_radius=5,
            # min_randomized_radius=5,
            # block='diamond_block',
            # placement='surface',
            # max_radius=5,
            # min_radius=0,
            # max_randomized_distance=5,
            # min_randomized_distance=0,
            # randomize_compass_location=False
            # ),
        ]

    def create_server_initial_conditions(self) -> List[Handler]:
        return [
            handlers.TimeInitialCondition(
                allow_passage_of_time=False,
                start_time=6000
            ),
            handlers.WeatherInitialCondition('clear'),
            handlers.SpawningInitialCondition('false')
        ]

    def get_docstring(self):
        return 'my env'

    def determine_success_from_rewards(self, rewards: list) -> bool:
        reward_threshold = 100.0
        return sum(rewards) >= reward_threshold

