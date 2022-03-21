
-- I more or less understand this function and the high level math behind it
-- Left off looking at https://github.com/love2d/love/blob/main/src/modules/math/BezierCurve.cpp to see what they do and it involves subdividing a larger bezier curve using some method to then rendering that with a degree of accuracy. The accuracy is used to determine the subdivision level

-- Options as they exist
-- port over love2d arbirary curve length - XL
-- try some concatenation logic to render roots based on 4 point bezier curves - M
-- looking at polygon support in playdate - S
-- trying to get the effect with arcs - M

local accuracy = 0.005
function bezier(t, p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
	-- not 100% sure what this math is doing outside of some bezier calculation based on control point t and influenced by 
	local cX = 3 * (p1X - p0X)
	local bX = 3 * (p2X - p1X) - cX
	local aX = p3X - p0X - cX - bX
	
	local cY = 3 * (p1Y - p0Y)
	local bY = 3 * (p2Y - p1Y) - cY
	local aY = p3Y - p0Y - cY - bY
	
	return ((aX * math.pow(t, 3)) + (bX * math.pow(t, 2)) + (cX * t) + p0X),
			((aY * math.pow(t, 3)) + (bY * math.pow(t, 2)) + (cY * t) + p0Y)
end

function curveLine(p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
	local x, y = p0X, p0Y
	local pX, pY = 0, 0
	
	print("("..p0X..","..p0Y..") ("..p1X..","..p1Y..") ("..p2X..","..p2Y..") ("..p3X..","..p3Y..")")

	for t = 0, 1, accuracy do
		pX, pY = bezier(t, p0X, p0Y, p1X, p1Y, p2X, p2Y, p3X, p3Y)
		
		gfx.drawLine(x, y, pX, pY)

		-- print("accuracy: "..t.." (x, y)= ("..x..","..y..") to (px,py): ("..pX..","..pY..")")
		x, y = pX, pY
	end
end

-- curveLine(10, 10, 30, 20, 30, 200, 380, 230)