; AutoLISP-Smiles is a project by Martin Poncio. More information at https://github.com/lmponcio/AutoLISP-Smiles
;
; The function `aits-happy` draws a happy face - please note it will erase elements in the area to clear space before drawing
; 
; Function execution example:
;	(aits-happy 10 22 10 15 1.8)
(defun aits-happy (
           face_bottom_left_corner_x_coord
		   face_bottom_left_corner_y_coord
		   face_width
		   face_height
		   mouth_height
		   /
		   ; zoom area points (vertices that describe the square to zoom in)
		   zoom_area_point_1
		   zoom_area_point_2

		   ; mouth placement conditions
		   horizontal_mouth_offset
		   vertical_mouth_offset
		   mouth_width
		   half_mouth_width

		   ; mouth coordinates
		   mouth_borders_y_coord ; both mouth borders have the same y coordinate
		   mouth_center_y_coord 
		   mouth_left_border_x_coord
		   mouth_right_border_x_coord
		   mouth_center_x_coord

		   ; mouth points created using mouth coordinates
		   mouth_start_point
		   mouth_center_point
		   mouth_end_point

		   ; face border coordinates
		   face_bottom_y_coord
		   face_top_y_coord
		   face_left_side_x_coord
		   face_right_side_x_coord

		   ; eyes placement conditions, height and width
		   horizontal_eye_offset
		   vertical_eye_offset 
		   eyes_height
		   eye_width
		   half_eye_width
		   
		   ; eyes coordinates
		   eye_centers_y_coord ; both eyes have the same y coordinates
		   eye_borders_y_coord ; both eyes have the same y coordinates
		   left_eye_left_border_x_coord
		   left_eye_right_border_x_coord
		   left_eye_center_x_coord
		   right_eye_left_border_x_coord
		   right_eye_right_border_x_coord
		   right_eye_center_x_coord

		   ; eyes points created using eyes coordinates
		   left_eye_left_point
		   left_eye_top_point
		   left_eye_right_point
		   right_eye_left_point
		   right_eye_top_point
		   right_eye_right_point		   
		  )
  
  
  ; calculating coordinates to zoom and erase
  (setq	zoom_area_point_1
	 (list
	   (- face_bottom_left_corner_x_coord 1)
	   (- face_bottom_left_corner_y_coord 1)
	 )
  )
  (setq	zoom_area_point_2
	 (list
	   (+ 1 (+ face_bottom_left_corner_x_coord face_width))
	   (+ 1 (+ face_bottom_left_corner_y_coord face_height))
	 )
  )  


  ; zoom to the area where we will draw the face
  (command "_.ZOOM" "_W" zoom_area_point_1 zoom_area_point_2)


  ; erase objects present in the area where we will draw the face
  (command "_.erase" "_window" zoom_area_point_1 zoom_area_point_2 "")

  ; calculating face border vertices coordinates
  (setq face_bottom_y_coord face_bottom_left_corner_y_coord)
  (setq face_top_y_coord (+ face_height face_bottom_left_corner_y_coord) )
  (setq face_left_side_x_coord face_bottom_left_corner_x_coord)
  (setq face_right_side_x_coord (+ face_width face_bottom_left_corner_x_coord))
  
  ; drawing face border using the coordinates
  (command "_.line" (list face_left_side_x_coord face_bottom_y_coord) (list face_left_side_x_coord face_top_y_coord) "") ; left side
  (command "_.line" (list face_left_side_x_coord face_top_y_coord) (list face_right_side_x_coord face_top_y_coord) "") ; top
  (command "_.line" (list face_right_side_x_coord face_top_y_coord) (list face_right_side_x_coord face_bottom_y_coord) "") ; right side
  (command "_.line" (list face_right_side_x_coord face_bottom_y_coord) (list face_left_side_x_coord face_bottom_y_coord) "") ; bottom

  ; hard-coded mouth placement conditions (they could be function arguments, hard-coded for simplicity)
  (setq vertical_mouth_offset 3) 
  (setq horizontal_mouth_offset 1)
  
  ; calculating coordinates of mouth points
  (setq mouth_borders_y_coord (+ face_bottom_left_corner_y_coord vertical_mouth_offset))
  (setq mouth_center_y_coord (- mouth_borders_y_coord mouth_height))
  (setq mouth_left_border_x_coord (+ face_left_side_x_coord horizontal_mouth_offset))
  (setq mouth_right_border_x_coord (- face_right_side_x_coord horizontal_mouth_offset)); mouth border 'x' coord is 1 offset from face border
  (setq mouth_width (- mouth_right_border_x_coord mouth_left_border_x_coord)) ; mouth_width changes with face_width (wider face, wider mouth)
  (setq half_mouth_width (/ mouth_width 2))
  (setq	mouth_center_x_coord (+ mouth_left_border_x_coord half_mouth_width))

  ; building the mouth points with previously calculated coordinates
  (setq mouth_start_point (list mouth_left_border_x_coord mouth_borders_y_coord))
  (setq mouth_center_point (list mouth_center_x_coord mouth_center_y_coord))
  (setq mouth_end_point (list mouth_right_border_x_coord mouth_borders_y_coord))

  ; draw happy face mouth and eyes using arcs
  (command "_.arc" mouth_start_point mouth_center_point mouth_end_point)

  ; hard-coded eyes placement conditions, height and width (they could be function arguments, hard-coded for simplicity)
   (setq horizontal_eye_offset 3)
   (setq vertical_eye_offset 2.8)
   (setq eyes_height 0.2)
   (setq eye_width 0.8)
   (setq half_eye_width (/ eye_width 2))

  ; eyes coordinates calculations
   (setq eye_centers_y_coord (- face_top_y_coord vertical_eye_offset))
   (setq eye_borders_y_coord (- eye_centers_y_coord eyes_height))
   (setq left_eye_left_border_x_coord (+ face_left_side_x_coord horizontal_eye_offset))
   (setq left_eye_right_border_x_coord (+ left_eye_left_border_x_coord eye_width))
   (setq left_eye_center_x_coord (+ left_eye_left_border_x_coord half_eye_width))
   (setq right_eye_right_border_x_coord (- face_right_side_x_coord horizontal_eye_offset))   
   (setq right_eye_left_border_x_coord (- right_eye_right_border_x_coord eye_width))
   (setq right_eye_center_x_coord (+ right_eye_left_border_x_coord half_eye_width))  

  ; eyes points calculations
  (setq left_eye_left_point (list left_eye_left_border_x_coord eye_borders_y_coord))
  (setq left_eye_right_point (list left_eye_right_border_x_coord eye_borders_y_coord))
  (setq left_eye_top_point (list left_eye_center_x_coord eye_centers_y_coord))
  (setq right_eye_left_point (list right_eye_left_border_x_coord eye_borders_y_coord))
  (setq right_eye_right_point (list right_eye_right_border_x_coord eye_borders_y_coord))
  (setq right_eye_top_point (list right_eye_center_x_coord eye_centers_y_coord))  
  
  ; drawing eyes
  (command "_.arc" left_eye_left_point left_eye_top_point left_eye_right_point)
  (command "_.arc" right_eye_left_point right_eye_top_point right_eye_right_point)

  (princ)
)
