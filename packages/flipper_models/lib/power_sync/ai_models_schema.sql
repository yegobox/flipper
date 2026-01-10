-- Drop the old table if it exists (since structure changed significantly)
DROP TABLE IF EXISTS ai_models CASCADE;

-- Create the new table structure
CREATE TABLE ai_models (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,                          -- Display name: "GPT-4", "Gemini 2.0 Flash"
  model_id TEXT NOT NULL,                      -- API model ID: "gpt-4", "gemini-2.0-flash-exp"
  provider TEXT NOT NULL,                      -- Provider: "openai", "gemini", "anthropic"
  api_standard TEXT DEFAULT 'gemini',          -- API Standard: "gemini" or "openai"
  api_url TEXT NOT NULL,                       -- Full API endpoint URL
  api_key TEXT,                                -- API key (encrypted in production)
  is_active BOOLEAN DEFAULT true,              -- Whether model is available for use
  is_default BOOLEAN DEFAULT false,            -- Default model for this business
  is_paid_only BOOLEAN DEFAULT false,          -- If true, requires paid subscription
  max_tokens INT DEFAULT 2048,                 -- Max output tokens
  temperature DECIMAL(3,2) DEFAULT 0.20,       -- Default temperature
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Business AI Configurations (Usage Tracking)
CREATE TABLE business_ai_configs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  business_id UUID NOT NULL REFERENCES businesses(id),  -- Links to Business (UUID)
  ai_model_id UUID REFERENCES ai_models(id),          -- Selected Model (null = global default)
  usage_limit INT DEFAULT 100,                        -- Request limit (starts small)
  current_usage INT DEFAULT 0,                        -- Counter for successful requests
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_ai_models_active ON ai_models(is_active) WHERE is_active = true;
CREATE INDEX idx_ai_models_provider ON ai_models(provider);
CREATE UNIQUE INDEX idx_business_ai_configs_business ON business_ai_configs(business_id);

-- Ensure only one global default
CREATE UNIQUE INDEX idx_unique_global_default 
ON ai_models((1)) 
WHERE is_default = true;

-- Updated timestamp trigger function
CREATE OR REPLACE FUNCTION update_ai_models_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER ai_models_updated_at
  BEFORE UPDATE ON ai_models
  FOR EACH ROW
  EXECUTE FUNCTION update_ai_models_updated_at();

CREATE TRIGGER business_ai_configs_updated_at
  BEFORE UPDATE ON business_ai_configs
  FOR EACH ROW
  EXECUTE FUNCTION update_ai_models_updated_at(); -- Reuse same function

-- Seed default models (global) - API keys should be configured via environment variables or admin UI
-- IMPORTANT: Never commit actual API keys to version control
INSERT INTO ai_models (id, name, model_id, provider, api_standard, api_url, api_key, is_active, is_default, max_tokens, temperature, created_at, updated_at, is_paid_only) VALUES
  ('7e6e67d9-bf7f-4246-92ee-f75d0cd25759', 'Gemini 2.0 Flash', 'gemini-2.0-flash-exp', 'gemini', 'gemini', 
   'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=', 
   NULL, true, true, 2048, 0.20, '2026-01-09 13:59:30.866611+00', '2026-01-09 14:00:58.184264+00', false),
  ('dd56efa8-2ea6-4f9d-984d-6cf8683b6063', 'Llama 3 8B', 'llama3-8b-8192', 'groq', 'openai', 
   'https://api.groq.com/openai/v1/chat/completions', 
   NULL, true, false, 2048, 0.20, '2026-01-09 13:59:30.866611+00', '2026-01-09 14:01:10.453358+00', false)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  model_id = EXCLUDED.model_id,
  provider = EXCLUDED.provider,
  api_standard = EXCLUDED.api_standard,
  api_url = EXCLUDED.api_url,
  api_key = EXCLUDED.api_key,
  is_active = EXCLUDED.is_active,
  is_default = EXCLUDED.is_default,
  max_tokens = EXCLUDED.max_tokens,
  temperature = EXCLUDED.temperature,
  updated_at = EXCLUDED.updated_at;

-- Function to get available models
DROP FUNCTION IF EXISTS get_available_ai_models();

CREATE OR REPLACE FUNCTION get_available_ai_models()
RETURNS TABLE (
  id UUID,
  name TEXT,
  model_id TEXT,
  provider TEXT,
  api_standard TEXT,
  api_url TEXT,
  is_default BOOLEAN,
  is_paid_only BOOLEAN,
  max_tokens INT,
  temperature DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    m.id, m.name, m.model_id, m.provider, m.api_standard, m.api_url, 
    m.is_default, m.is_paid_only, m.max_tokens, m.temperature
  FROM ai_models m
  WHERE m.is_active = true
  ORDER BY m.is_default DESC, m.name ASC;
END;
$$ LANGUAGE plpgsql;