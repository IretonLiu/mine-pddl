from enum import Enum


class TypeName(Enum):
    OBJECT_TYPE_NAME = "object"
    LOCATABLE_TYPE_NAME = "locatable"
    AGENT_TYPE_NAME = "agent"
    ITEM_TYPE_NAME = "item"
    BLOCK_TYPE_NAME = "block"
    DESTRUCTIBLE_BLOCK_TYPE_NAME = "destructible-block"
    BEDROCK_TYPE_NAME = "bedrock"
    INTEGER_TYPE_NAME = "int"
    POSITION_TYPE_NAME = "position"
    COUNT_TYPE_NAME = "count"
