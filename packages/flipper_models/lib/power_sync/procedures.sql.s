CREATE OR REPLACE FUNCTION public.deduct_credits(branch_id INTEGER, amount INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  current_credits INTEGER;  -- Declare a variable to hold the current credits
BEGIN
  -- Lock the row in the credits table AND store the result
  SELECT c.credits INTO current_credits FROM public.credits AS c WHERE c.branch_server_id = deduct_credits.branch_id FOR UPDATE;
  -- Check if the branch has enough credits
  IF current_credits < amount THEN
    RAISE EXCEPTION 'Insufficient credits for branch %', deduct_credits.branch_id;
  END IF;
  -- Deduct the credits
  UPDATE public.credits
  SET credits = credits - amount
  WHERE branch_server_id = deduct_credits.branch_id;
END;
$$;