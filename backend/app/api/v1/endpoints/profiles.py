from typing import List, Optional

from backend.app.schemas.profile import ApplianceProfileSchema, ApplianceProfileSummarySchema
from fastapi import APIRouter, HTTPException, Query

router = APIRouter()

# Seed catalog of verified appliance profiles
VERIFIED_PROFILES: List[ApplianceProfileSchema] = [
    ApplianceProfileSchema(
        id="panasonic_nn_sd372s_microwave",
        name="Panasonic Inverter Microwave Oven NN-SD372S",
        manufacturer="Panasonic",
        modelNumber="NN-SD372S",
        category="microwave",
        schemaVersion="1.0.0",
        verificationStatus="verified",
        controls=[
            {
                "id": "ctrl_start_add30s",
                "name": "Start / Quick 30",
                "type": "button",
                "normalizedBoundingBox": {
                    "left": 0.55,
                    "top": 0.78,
                    "right": 0.92,
                    "bottom": 0.88,
                },
                "ocrKeyTerms": ["Start", "Quick 30", "+30s"],
                "functionDescription": "Starts microwave cooking or adds 30 seconds at high power.",
                "audioCueText": "Start and Quick thirty seconds button. Located bottom right.",
                "tactileFeature": "Smooth round button with raised center pip",
                "safetyWarning": "Starts immediate heating when door is securely latched.",
            },
            {
                "id": "ctrl_stop_reset",
                "name": "Stop / Reset",
                "type": "button",
                "normalizedBoundingBox": {
                    "left": 0.08,
                    "top": 0.78,
                    "right": 0.45,
                    "bottom": 0.88,
                },
                "ocrKeyTerms": ["Stop", "Reset", "Clear"],
                "functionDescription": "Cancels current operation or resets cooking time.",
                "audioCueText": "Stop and Reset button. Located bottom left.",
                "tactileFeature": "Smooth round button with indented center",
            },
        ],
    )
]


@router.get(
    "/profiles",
    response_model=List[ApplianceProfileSummarySchema],
    summary="List verified profiles",
)
def list_profiles(
    category: Optional[str] = Query(None, description="Appliance category filter"),
    query: Optional[str] = Query(None, description="Search term"),
):
    results = VERIFIED_PROFILES
    if category:
        results = [p for p in results if p.category.lower() == category.lower()]
    if query:
        q = query.lower()
        results = [
            p for p in results
            if q in p.name.lower() or q in p.manufacturer.lower() or q in p.modelNumber.lower()
        ]
    return results


@router.get(
    "/profiles/{profile_id}",
    response_model=ApplianceProfileSchema,
    summary="Get full verified profile",
)
def get_profile_by_id(profile_id: str):
    for p in VERIFIED_PROFILES:
        if p.id == profile_id:
            return p
    raise HTTPException(status_code=404, detail=f"Profile '{profile_id}' not found")
