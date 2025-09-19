from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

from routers import users, pets, orders, adoptions, appointments, visits

# Load environment variables
load_dotenv()

app = FastAPI(title="PetLove API", description="PetLove Backend API in Python", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB connection
@app.on_event("startup")
async def startup_db_client():
    app.mongodb_client = AsyncIOMotorClient(os.getenv("MONGODB_URI"))
    app.mongodb = app.mongodb_client.petlove
    print("Connected to MongoDB!")

@app.on_event("shutdown")
async def shutdown_db_client():
    app.mongodb_client.close()

# Include routers
app.include_router(users.router, prefix="/api/users", tags=["users"])
app.include_router(pets.router, prefix="/api/pets", tags=["pets"])
app.include_router(orders.router, prefix="/api/orders", tags=["orders"])
app.include_router(adoptions.router, prefix="/api/adoptions", tags=["adoptions"])
app.include_router(appointments.router, prefix="/api/appointments", tags=["appointments"])
app.include_router(visits.router, prefix="/api/visits", tags=["visits"])

@app.get("/")
async def root():
    return {"message": "PetLove API Running!"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 5000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)
