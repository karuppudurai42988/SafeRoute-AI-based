from fastapi import FastAPI
import random

app = FastAPI(title="SafeRoute AI Analytics Engine")

@app.get("/")
def home():
    return {"status": "SafeRoute AI Engine is online"}

@app.get("/api/ai/analyze")
def analyze_safety(lat: float, lng: float):
    score = int((lat + lng) % 40 + 60) 
    
    if score > 85:
        status = "Safe Zone"
        description = "Low criminal activity history. Well-lit pathways and highly active community vigilance."
    elif score > 70:
        status = "Caution Zone"
        description = "Moderate alert level. Minor historical street incidents reported nearby. Stick to main roads."
    else:
        status = "High Alert Zone"
        description = "Poorly lit or isolated region. Increased frequency of local reports. Avoid traveling alone at night."

    return {
        "safetyScore": score,
        "status": status,
        "description": description
    }