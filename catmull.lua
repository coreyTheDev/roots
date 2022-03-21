local stepsPerCurve = 10
local tension = 2
function generateSpline(points)
	local result = {}

	for i=1, #points - 1 do -- iterating through points - 1
	  -- drawing a curve between 2 points
		local p0
		if i == 1 then p0 = points[i] else p0 = points[i - 1] end
		local p1 = points[i]
		local p2 = points[i + 1]
		local p3
		if i == #points - 1 then p3 = points[i + 1] else p3=points[i + 2] end

		for step = 0, stepsPerCurve do -- (int step = 0; step <= stepsPerCurve; step++)
			local t = step / stepsPerCurve -- dynamic t to generate a step (essentially a line from a calculated point)
			local tSquared = t * t
			local tCubed = tSquared * t

			local interpolatedX = (-.5 * tension * tCubed + tension * tSquared - .5 * tension * t) * p0.x +
			(1 + .5 * tSquared * (tension - 6) + .5 * tCubed * (4 - tension)) * p1.x +
			(.5 * tCubed * (tension - 4) + .5 * tension * t - (tension - 3) * tSquared) * p2.x +
			(-.5 * tension * tSquared + .5 * tension * tCubed) * p3.x
			
			local interpolatedY = (-.5 * tension * tCubed + tension * tSquared - .5 * tension * t) * p0.y +
			(1 + .5 * tSquared * (tension - 6) + .5 * tCubed * (4 - tension)) * p1.y +
			(.5 * tCubed * (tension - 4) + .5 * tension * t - (tension - 3) * tSquared) * p2.y +
			(-.5 * tension * tSquared + .5 * tension * tCubed) * p3.y
			-- this is matrix math done directly on vectors and I'm trying to convert directly to x/y
			-- Vector3 interpolatedPoint =
			-- 	(-.5f * tension * tCubed + tension * tSquared - .5f * tension * t) * prev +
			-- 	(1 + .5f * tSquared * (tension - 6) + .5f * tCubed * (4 - tension)) * currStart +
			-- 	(.5f * tCubed * (tension - 4) + .5f * tension * t - (tension - 3) * tSquared) * currEnd +
			-- 	(-.5f * tension * tSquared + .5f * tension * tCubed) * next;

			local interpolatedPoint = playdate.geometry.point.new(interpolatedX, interpolatedY)
			table.insert(result, interpolatedPoint)
		end
	end

	return result
end
