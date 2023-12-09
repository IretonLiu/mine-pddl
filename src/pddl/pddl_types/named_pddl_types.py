from pddl.pddl_types.base_pddl_types import DestructibleBlockType, ItemType


class NamedItemType(ItemType):
    type_name = "named_item"

    def __init__(
        self,
        use_propositional: bool,
        item_name: str = "default",
        variation: str = "",
        quantity: int = 0,
        in_inventory: bool = False,
    ):
        super().__init__(use_propositional)
        self.name = item_name
        self.name = self.name.replace(" ", "_")
        self.variation = variation
        self.quantity = quantity  # only used if Minecraft has grouped items together
        self.in_inventory = in_inventory


class NamedBlockType(DestructibleBlockType):
    def __init__(
        self,
        use_propositional: bool,
        block_name: str = "default",
    ):
        super().__init__(use_propositional)
        self.name = block_name
        self.name = self.name.replace(" ", "_")
