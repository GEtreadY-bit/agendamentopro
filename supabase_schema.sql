-- Create the appointments table
CREATE TABLE IF NOT EXISTS public.appointments (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    client_name text NOT NULL,
    client_phone text NOT NULL,
    service_type text NOT NULL,
    appointment_date date NOT NULL,
    appointment_time time without time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    
    -- Constraint to validate status
    CONSTRAINT valid_status CHECK (status IN ('scheduled', 'cancelled', 'completed'))
);

-- Add a unique index to prevent double bookings on the same day and time
-- This guarantees that two active appointments cannot exist at the exact same time
CREATE UNIQUE INDEX IF NOT EXISTS unique_active_appointment 
ON public.appointments (appointment_date, appointment_time) 
WHERE status = 'scheduled';

-- Set up Row Level Security (RLS)
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to insert appointments
CREATE POLICY "Allow anonymous inserts" ON public.appointments
    FOR INSERT
    TO anon
    WITH CHECK (true);

-- Allow anonymous users to select appointments
CREATE POLICY "Allow anonymous selects" ON public.appointments
    FOR SELECT
    TO anon
    USING (true);

-- Allow anonymous users to update (e.g. cancel) appointments
CREATE POLICY "Allow anonymous updates" ON public.appointments
    FOR UPDATE
    TO anon
    USING (true);
