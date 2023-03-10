class Function:
    def __init__(self):
        raise NotImplementedError()

    def to_pddl(self):
        raise NotImplementedError()


class InventoryFunction(Function):
    def __init__(self, object):
        self.var_name = "agent-num-{}"
        self.parameter_name = object.name
        self.object_type = object.type_name

    def to_pddl(self, item_name):
        return "({} {} - {})".format(
            self.var_name.format(item_name), self.parameter_name, self.object_type
        )


class PositionFunction(Function):
    def __init__(self, object):
        self.parameter_name = object.name
        self.object_type = object.type_name

        self.position = None

    def set_position(self, position):
        self.position = position

    def to_pddl(self):
        return "({} {} - {})\n({} {} - {})\n({} {} - {})".format(
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


class BlockHitsFunction(Function):
    def __init__(self, object):
        self.var_name = "block-hits"
        self.parameter_name = object.name
        self.object_type = object.type_name

    def to_pddl(self):
        return "({} {} - {})".format(
            self.var_name, self.parameter_name, self.object_type
        )


# TODO : add more functions
