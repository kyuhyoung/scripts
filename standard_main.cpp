cv::String keys =
    //"{@image            |<none>             | input image path}"         // input image is the first argument (positional)
    //"{@face             |/path/to/file.xml  | face cascade path}"        // optional, face cascade is the second argument (positional)
    "{idx_init          |0                  | Initial index of image file or pose file}"
    "{n_pose            |4                   | Number of images or poses}"
    "{th_err_pxl        |-1                   | Threshold of pixel error for inlier}"
    "{is_robot_eye      |0                  | Zero if hand-eye calibration. Non-zero if robot-eye calibration.}"         // optional, default value ""
    "{input_mode        |                   | Should be one of 'pnp', 'image', 'image+p2d' and 'p2d'.}"
    "{dir_p2d           |                   | Directory of Matlab toolbox corner det results}"
    "{p2d_refine_he     |                  | Use Matlab toolbox corner det results for seed of chessboard refinement in HE if non-zero}"
    "{is_verbose        |0                  | Print out optimization process during st-handeye interation}"
    "{unit_meter        |1                  | The unit of translation is millimeter if this is 0. Otherwise meter}"         // optional, default value ""
    "{robot_type        |UR                | Robot type}"         // optional, default value ""
    "{img_ext           |bmp                | Image file extension}"         // optional, default value ""
    "{prefix_corner     |                   | Prefix of Matlab corner files}"
    "{yml_cam           |                   | Path to camera instrinsic parameter yml file}"
    "{is_calib_test     |                  | Zero if it is for handeye or roboteye calibration. Nonzero if it is for calibration test}"
    "{path_img_chessboard    |                   | Path to chessboard image }"
    "{mm_gripper            |                   | Physical length of gripper in millimeter}"
    "{mm_tip            |                   | Physical length of additional tip mounted on gripper in millimeter}"         // optional, default value ""
    "{help      |      | show help message}";      // optional, show help optional
 int main( int argc, char* argv[] )
 {
     CommandLineParser parser( argc, argv, keys );
     parser.about( "Application name v1.0.0" );
     if ( parser.has( "help" ) ) { parser.printMessage();  return 0; }
     bool is_robot_eye = 0 != parser.get<int>( "is_robot_eye" );
     std::string path_calib_yml = parser.get<std::string>( "path_calib_yml" );
     bool is_calib_test = 0 != parser.get<int>( "is_calib_test" );
     std::string yml_cam = parser.get<std::string>( "yml_cam" );
     std::string yml_chessboard = parser.get<std::string>( "yml_chessboard" );
     std::string yml_bMc_or_eMc = parser.get<std::string>( "yml_bMc_or_eMc" );
     std::string yml_bMe = parser.get<std::string>( "yml_bMe" );
     std::string yml_eTt_meter = parser.get<std::string>( "yml_eTt_meter" );
     bool is_unit_meter = 0 != parser.get<int>( "unit_meter" );
     std::string path_img_chessboard = parser.get<std::string>( "path_img_chessboard" );
     float mm_gripper = parser.get<float>( "mm_gripper" ), mm_tip = parser.get<int>( "mm_tip" );
     std::string str_robot_type = parser.get<std::string>( "robot_type" );
 }  
