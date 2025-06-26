from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def read_events() -> dict:
    return {
        "message": "List of events"
    }

@router.get('/')
def read_event():
    return {
        {'id': 1}
    }