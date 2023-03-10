import numpy as np

from minedojo.sim import spaces
from minedojo.sim.handlers.translation import KeymapTranslationHandler


class EntityObservation(KeymapTranslationHandler):
    """
    Handles entity observations.
    A JSON array will be returned for each range requested, named using the {{{ name }}} attribute of the
    range. Within the array will be a series of elements, one for each entity, containing the following:

    - name: a string describing the entity (eg from Types.xsd)

    - x: the x position of the entity

    - y: the y position of the entity

    - z: the z position of the entity

    - quantity: if items have been grouped together by Minecraft, this indicates the number in the stack

    - colour: if the item is a tile entity, with a colour, this will be present to describe the colour

    - variation: optional string to describe the variation - eg the type of egg, or brick, etc (see
    Types.xsd)
    """

    def to_hero(self, x) -> str:
        pass

    def to_string(self):
        return "entities"

    def xml_template(self) -> str:
        return str(
            f"""
            <ObservationFromNearbyEntities>                      
                <Range name="entities" xrange="{self.xrange}" yrange="{self.yrange}" zrange="{self.zrange}"/>   
            </ObservationFromNearbyEntities>"""
        )

    def __init__(self, ranges=(1, 1, 1)):
        self.xrange = ranges[0]
        self.yrange = ranges[1]
        self.zrange = ranges[2]

        space = spaces.Dict(
            {
                # "entity_name": spaces.Text(shape=self.grid_size),
                # # max block meta is 120, i.e., item id 383:120 spawn egg for villager
                # # see https://minecraft-ids.grahamedgecombe.com/
                # "block_meta": spaces.Box(
                #     low=0, high=120, shape=self.grid_size, dtype=np.int64
                # ),
                # "is_collidable": spaces.Box(
                #     low=0, high=1, shape=self.grid_size, dtype=bool
                # ),
                # "is_tool_not_required": spaces.Box(
                #     low=0, high=1, shape=self.grid_size, dtype=bool
                # ),
                # "blocks_movement": spaces.Box(
                #     low=0, high=1, shape=self.grid_size, dtype=bool
                # ),
                # "is_liquid": spaces.Box(
                #     low=0, high=1, shape=self.grid_size, dtype=bool
                # ),
                # "is_solid": spaces.Box(low=0, high=1, shape=self.grid_size, dtype=bool),
                # "can_burn": spaces.Box(low=0, high=1, shape=self.grid_size, dtype=bool),
                # "blocks_light": spaces.Box(
                #     low=0, high=1, shape=self.grid_size, dtype=bool
                # ),
                # "cos_look_vec_angle": spaces.Box(
                #     low=-1, high=1, shape=self.grid_size, dtype=np.float32
                # ),
            }
        )
        # gym.space.Dict will sort keys! So we keep the order by ourselves
        # self._key_list = [
        #     "block_name",
        #     "block_meta",
        #     "is_collidable",
        #     "is_tool_not_required",
        #     "blocks_movement",
        #     "is_liquid",
        #     "is_solid",
        #     "can_burn",
        #     "blocks_light",
        #     "cos_look_vec_angle",
        # ]
        super().__init__(hero_keys=["entities"], univ_keys=["entities"], space=space)

    def from_hero(self, obs):
        # pass
        return obs["entities"]
        # voxels_arr = obs[self.hero_keys[0]]
        # assert len(voxels_arr) == np.prod(self.grid_size) * len(
        #     self._key_list
        # ), "INTERNAL"
        # # yunfan: note that returns from java side are in F order, we need to use F order to be consistent
        # return {
        #     key: np.array(
        #         [
        #             voxels_arr[i]
        #             for i in range(bias, len(voxels_arr), len(self._key_list))
        #         ],
        #         dtype=self.space[key].dtype,
        #     ).reshape(self.space[key].shape, order="F")
        #     for bias, key in enumerate(self._key_list)
        # }

    def __or__(self, other):
        pass
        # """
        # Combines two voxel observations into one. If all of the properties match return self
        # otherwise raise an exception.
        # """
        # if (
        #     isinstance(other, EntityObservation)
        #     and self.grid_min == other.grid_min
        #     and self.grid_max == other.grid_max
        # ):
        #     return self
        # else:
        #     raise ValueError("Incompatible observables!")
