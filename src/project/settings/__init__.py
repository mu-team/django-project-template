from .common import *

try:
    from .local import *
except ImportError as exc:
    raise ImportError(
        'Could not import `local.py` module. '
        'Make sure that local settings available in project.'
    ) from exc
