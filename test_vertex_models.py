import os
from google import genai
from dotenv import load_dotenv

load_dotenv()

# Test Vertex AI initialization and model discovery
project_id = os.getenv("GCP_PROJECT_ID")
if not project_id:
    print("Please set GCP_PROJECT_ID")
    exit(1)

client = genai.Client(vertexai=True, project=project_id, location="us-central1")

print(f"Connected to Vertex AI in {project_id} (us-central1)")
print("Fetching available models...")

try:
    models = client.models.list()
    print("Available Models:")
    for m in models:
        # Vertex AI models typically start with 'gemini' 
        if "gemini" in m.name.lower():
            print(f" - {m.name}")
            
    print("\nAttempting direct inference with 'gemini-1.5-flash-001'...")
    response = client.models.generate_content(
        model="gemini-1.5-flash-001",
        contents="Hello Vertex AI! Are you online?"
    )
    print(f"SUCCESS! Response: {response.text}")
    
except Exception as e:
    print(f"Error: {e}")
