from typing import List


class Function:
    def __init__(self):
        raise NotImplementedError()

    def set_value(self, value):
        raise NotImplementedError()

    def to_pddl(self):
        raise NotImplementedError()

    def to_pddl_with_values(self, parent_object_name: str):
        raise NotImplementedError()


class InventoryFunction(Function):
    def __init__(self, object):
        self.var_name = "agent-num-{}"
        self.parameter_name = object.name
        self.object_type = object.type_name
        self.value = 0

    def set_value(self, value):
        self.value = value

    def to_pddl(self, item_name):
        return "({} ?{} - {})".format(
            self.var_name.format(item_name), self.parameter_name, self.object_type
        )

    def to_pddl_with_values(self, parent_object_name: str, item_name: str, count: int):
        # (= (agent-num-potato steve) 0)
        return f"(= ({self.var_name.format(item_name)} {parent_object_name}) {count})"


class PositionFunction(Function):
    def __init__(self, object, type_name):
        self.parameter_name = object.name
        self.object_type = type_name

        self.value = None

    def set_value(self, value):
        self.value = value

    def to_pddl(self):
        return "({} ?{} - {})\n\t({} ?{} - {})\n\t({} ?{} - {})".format(
            "x",
            self.parameter_name,
            self.object_type,
            "y",
            self.parameter_name,
            self.object_type,
            "z",
            self.parameter_name,
            self.object_type,
        )

    def to_pddl_with_values(self, parent_object_name: str):
        """
        (= (x old-pointy) 0)
        (= (y old-pointy) 0)
        (= (z old-pointy) 0)
        """
        return "(= ({} {}) {})\n\t(= ({} {}) {})\n\t(= ({} {}) {})".format(
            "x",
            parent_object_name,
            self.value[0],
            "y",
            parent_object_name,
            self.value[1],
            "z",
            parent_object_name,
            self.value[2],
        )


class BlockHitsFunction(Function):
    def __init__(self, object):
        self.var_name = "block-hits"
        self.parameter_name = object.name
        self.object_type = object.type_name
        self.value = 0

    def set_value(self, value):
        self.value = value

    def to_pddl(self):
        return "({} ?{} - {})".format(
            self.var_name, self.parameter_name, self.object_type
        )

    def to_pddl_with_values(self, parent_object_name: str):
        # (= (block-hits obsidian0) 0)
        return f"(= ({self.var_name} {parent_object_name}) {self.value})"
