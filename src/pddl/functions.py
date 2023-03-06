class Function:
    def __init__(self):
        raise NotImplementedError()


class InventoryFunction(Function):
    def __init__(self, object):
        self.var_name = 'agent-num-{}'
        self.parameter_name = object.name
        self.object_type = object.type_name

    def to_string(self):
        return '{} {} - {}'.format(self.var_name, self.parameter_name, self.object_type)


class PositionFunction(Function):
    def __init__(self, object):
        self.parameter_name = object.name
        self.object_type = object.type_name

        self.position = None

    def set_position(self, position):
        self.position = position

    def to_string(self):
        raise NotImplementedError()


class BlockHitsFunction(Function):
    def __init__(self, object):
        self.parameter_name = object.name
        self.object_type = object.type_name

    def to_string(self):
        raise NotImplementedError()

# TODO : add more functions
