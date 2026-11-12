from typing import List, Optional

from pydantic import BaseModel, Field


class NormalizedBoundingBoxSchema(BaseModel):
    left: float = Field(..., ge=0.0, le=1.0)
    top: float = Field(..., ge=0.0, le=1.0)
    right: float = Field(..., ge=0.0, le=1.0)
    bottom: float = Field(..., ge=0.0, le=1.0)


class ControlElementSchema(BaseModel):
    id: str
    name: str
    type: str
    normalizedBoundingBox: NormalizedBoundingBoxSchema
    ocrKeyTerms: List[str] = []
    functionDescription: str
    audioCueText: str
    tactileFeature: Optional[str] = None
    safetyWarning: Optional[str] = None


class ApplianceProfileSummarySchema(BaseModel):
    id: str
    name: str
    manufacturer: str
    modelNumber: str
    category: str
    schemaVersion: str = "1.0.0"


class ApplianceProfileSchema(ApplianceProfileSummarySchema):
    verificationStatus: str = "verified"
    controls: List[ControlElementSchema]
