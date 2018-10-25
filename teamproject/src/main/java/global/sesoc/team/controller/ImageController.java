package global.sesoc.team.controller;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.Character.UnicodeBlock;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.opencv.calib3d.Calib3d;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfByte;
import org.opencv.core.MatOfDMatch;
import org.opencv.core.MatOfKeyPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.features2d.DMatch;
import org.opencv.features2d.DescriptorExtractor;
import org.opencv.features2d.DescriptorMatcher;
import org.opencv.features2d.FeatureDetector;
import org.opencv.features2d.KeyPoint;
import org.opencv.highgui.Highgui;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.cloud.vision.v1.AnnotateImageRequest;
import com.google.cloud.vision.v1.AnnotateImageResponse;
import com.google.cloud.vision.v1.BatchAnnotateImagesResponse;
import com.google.cloud.vision.v1.Block;
import com.google.cloud.vision.v1.Feature;
import com.google.cloud.vision.v1.Feature.Type;
import com.google.cloud.vision.v1.Image;
import com.google.cloud.vision.v1.ImageAnnotatorClient;
import com.google.cloud.vision.v1.ImageContext;
import com.google.cloud.vision.v1.Page;
import com.google.cloud.vision.v1.Paragraph;
import com.google.cloud.vision.v1.Symbol;
import com.google.cloud.vision.v1.TextAnnotation;
import com.google.cloud.vision.v1.Word;
import com.google.protobuf.ByteString;

import global.sesoc.team.vo.Order; 

class Test {
	public static void loadOpenCVNativeLibrary() {
		nu.pattern.OpenCV.loadShared();
	}
}

@Controller
public class ImageController {
	static {
		Test.loadOpenCVNativeLibrary();
	}
	
	@ResponseBody
	@RequestMapping(value = "/recognize", method = RequestMethod.POST)
	public HashMap<String, Object> recognize(Model model, MultipartHttpServletRequest multipartRequest, HttpSession session, ServletRequest req, String scheduleNo) throws FileNotFoundException, IOException {
		// 이미지파일을 저장할 기본 경로 설정
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		
		// 영수증 이미지를 저장
		Iterator<String> itr = multipartRequest.getFileNames();
		MultipartFile mpf = multipartRequest.getFile(itr.next());
		File receiptImage 	= new File(defaultRoute + "uploadedFile.jpg");
		mpf.transferTo(receiptImage);

		// 전체이미지 (영수증)
		String entireScene 	= defaultRoute + "uploadedFile.jpg";
		// 템플릿 이미지 (노브랜드, 구 매, 단가, ?)
		String ti_nobrand 	= defaultRoute + "nobrand\\ti_nobrand.jpg";
		String ti_date 		= defaultRoute + "nobrand\\ti_date.jpg";
		String ti_unitprice = defaultRoute + "nobrand\\ti_unitprice.jpg";
		String ti_listend 	= defaultRoute + "nobrand\\ti_listend.jpg";
		// 읽게할 작은 이미지들
		String crop_storename 	= defaultRoute + "sq_storename.jpg";
		String crop_date 		= defaultRoute + "sq_date.jpg";
		String crop_orderlist 	= defaultRoute + "sq_orderlist.jpg";

		// 이미지 불러오기
		System.out.println("이미지를 불러오는 중입니다..");
		Mat sceneImage = Highgui.imread(entireScene, Highgui.CV_LOAD_IMAGE_COLOR);
	    Mat objectImage1 = Highgui.imread(ti_nobrand, Highgui.CV_LOAD_IMAGE_COLOR);
	    Mat objectImage2 = Highgui.imread(ti_date, Highgui.CV_LOAD_IMAGE_COLOR);
	    Mat objectImage3 = Highgui.imread(ti_unitprice, Highgui.CV_LOAD_IMAGE_COLOR);
	    Mat objectImage4 = Highgui.imread(ti_listend, Highgui.CV_LOAD_IMAGE_COLOR);
	    
	    // 검색 범위 비율 (높을수록 많은 매치포인트를 캐치함)
	    float nndrRatio = 0.7f;
	
	    // 매칭 성공시 crop할 이미지들의 첫번째 좌표, width, height 정보를 저장할 리스트들
	    ArrayList<Point> squarePoints = new ArrayList<Point>();
	    ArrayList<Integer> squareWidths = new ArrayList<Integer>();
	    ArrayList<Integer> squareHeights = new ArrayList<Integer>();
	
	    // SIFT or SURF //
	    System.out.println("SIFT를 수행하는 중입니다..");
	    FeatureDetector featureDetector = FeatureDetector.create(FeatureDetector.SIFT);
	    DescriptorExtractor descriptorExtractor = DescriptorExtractor.create(DescriptorExtractor.SIFT);
	    
	    // ti_nobrand 이미지의 keypoint 찾기
	    System.out.println("keypoint를 찾는 중입니다..");
	    MatOfKeyPoint objectKeyPoints1 = new MatOfKeyPoint();
	    featureDetector.detect(objectImage1, objectKeyPoints1);
	    MatOfKeyPoint objectDescriptors1 = new MatOfKeyPoint();
	    descriptorExtractor.compute(objectImage1, objectKeyPoints1, objectDescriptors1);
	    Mat outputImage1 = new Mat(objectImage1.rows(), objectImage1.cols(), Highgui.CV_LOAD_IMAGE_COLOR);
	    
	    // ti_date 이미지의 keypoint 찾기
	    MatOfKeyPoint objectKeyPoints2 = new MatOfKeyPoint();
	    featureDetector.detect(objectImage2, objectKeyPoints2);
	    MatOfKeyPoint objectDescriptors2 = new MatOfKeyPoint();
	    descriptorExtractor.compute(objectImage2, objectKeyPoints2, objectDescriptors2);
	    Mat outputImage2 = new Mat(objectImage2.rows(), objectImage2.cols(), Highgui.CV_LOAD_IMAGE_COLOR);
		
	    // ti_listend 이미지의 keypoint 찾기
	    MatOfKeyPoint objectKeyPoints3 = new MatOfKeyPoint();
	    featureDetector.detect(objectImage3, objectKeyPoints3);
	    MatOfKeyPoint objectDescriptors3 = new MatOfKeyPoint();
	    descriptorExtractor.compute(objectImage3, objectKeyPoints3, objectDescriptors3);
	    Mat outputImage3 = new Mat(objectImage3.rows(), objectImage3.cols(), Highgui.CV_LOAD_IMAGE_COLOR);
	    
	    // ti_unitprice 이미지의 keypoint 찾기
	    MatOfKeyPoint objectKeyPoints4 = new MatOfKeyPoint();
	    featureDetector.detect(objectImage4, objectKeyPoints4);
	    MatOfKeyPoint objectDescriptors4 = new MatOfKeyPoint();
	    descriptorExtractor.compute(objectImage4, objectKeyPoints4, objectDescriptors4);
	    Mat outputImage4 = new Mat(objectImage4.rows(), objectImage4.cols(), Highgui.CV_LOAD_IMAGE_COLOR);
	    
	    // scene 이미지의 keypoint 찾기
	    MatOfKeyPoint sceneKeyPoints = new MatOfKeyPoint();
	    MatOfKeyPoint sceneDescriptors = new MatOfKeyPoint();
	    featureDetector.detect(sceneImage, sceneKeyPoints);
	    descriptorExtractor.compute(sceneImage, sceneKeyPoints, sceneDescriptors);
	    
	    Scalar greenColor = new Scalar(0, 255, 0);
	    List<MatOfDMatch> matches1 = new LinkedList<MatOfDMatch>();
	    List<MatOfDMatch> matches2 = new LinkedList<MatOfDMatch>();
	    List<MatOfDMatch> matches3 = new LinkedList<MatOfDMatch>();
	    List<MatOfDMatch> matches4 = new LinkedList<MatOfDMatch>();
	    DescriptorMatcher descriptorMatcher1 = DescriptorMatcher.create(DescriptorMatcher.FLANNBASED);
	    DescriptorMatcher descriptorMatcher2 = DescriptorMatcher.create(DescriptorMatcher.FLANNBASED);
	    DescriptorMatcher descriptorMatcher3 = DescriptorMatcher.create(DescriptorMatcher.FLANNBASED);
	    DescriptorMatcher descriptorMatcher4 = DescriptorMatcher.create(DescriptorMatcher.FLANNBASED);
	    descriptorMatcher1.knnMatch(objectDescriptors1, sceneDescriptors, matches1, 2);
	    descriptorMatcher2.knnMatch(objectDescriptors2, sceneDescriptors, matches2, 2);
	    descriptorMatcher3.knnMatch(objectDescriptors3, sceneDescriptors, matches3, 2);
	    descriptorMatcher4.knnMatch(objectDescriptors4, sceneDescriptors, matches4, 2);
	    
	    // 특징점 비교해서 일치하는 특징점들을 각 이미지의 goodMatcheList에 넣는 작업
	    System.out.println("이미지의 특징점을 비교 중입니다..");
	    LinkedList<DMatch> goodMatchesList1 = new LinkedList<DMatch>();
	    for (int i = 0; i < matches1.size(); i++) {
	        MatOfDMatch matofDMatch = matches1.get(i);
	        DMatch[] dmatcharray = matofDMatch.toArray();
	        DMatch m1 = dmatcharray[0];
	        DMatch m2 = dmatcharray[1];
	        if (m1.distance <= m2.distance * nndrRatio) {
	            goodMatchesList1.addLast(m1);
	        }
	        if (goodMatchesList1.size() > 50)
	        	break;
	    }
	    LinkedList<DMatch> goodMatchesList2 = new LinkedList<DMatch>();
	    for (int i = 0; i < matches2.size(); i++) {
	        MatOfDMatch matofDMatch = matches2.get(i);
	        DMatch[] dmatcharray = matofDMatch.toArray();
	        DMatch m1 = dmatcharray[0];
	        DMatch m2 = dmatcharray[1];
	        if (m1.distance <= m2.distance * nndrRatio) {
	            goodMatchesList2.addLast(m1);
	        }
	        if (goodMatchesList2.size() > 50)
	        	break;
	    }
	    LinkedList<DMatch> goodMatchesList3 = new LinkedList<DMatch>();
	    for (int i = 0; i < matches3.size(); i++) {
	        MatOfDMatch matofDMatch = matches3.get(i);
	        DMatch[] dmatcharray = matofDMatch.toArray();
	        DMatch m1 = dmatcharray[0];
	        DMatch m2 = dmatcharray[1];
	        if (m1.distance <= m2.distance * nndrRatio) {
	            goodMatchesList3.addLast(m1);
	        }
	        if (goodMatchesList3.size() > 50)
	        	break;
	    }
	    LinkedList<DMatch> goodMatchesList4 = new LinkedList<DMatch>();
	    for (int i = 0; i < matches4.size(); i++) {
	        MatOfDMatch matofDMatch = matches4.get(i);
	        DMatch[] dmatcharray = matofDMatch.toArray();
	        DMatch m1 = dmatcharray[0];
	        DMatch m2 = dmatcharray[1];
	        if (m1.distance <= m2.distance * nndrRatio) {
	            goodMatchesList4.addLast(m1);
	        }
	        if (goodMatchesList4.size() > 50)
	        	break;
	    }
	    
	    // 매칭에 성공한 곳을 네모로 표시할 이미지
	    Mat img = Highgui.imread(entireScene, Highgui.CV_LOAD_IMAGE_COLOR);
	
	    // 1. no brand로고 이미지를 찾았을 경우 처리
	    if (goodMatchesList1.size() >= 4) {
	        System.out.println("로고를 찾았습니다.");
	        List<KeyPoint> objKeypointlist = objectKeyPoints1.toList();
	        List<KeyPoint> scnKeypointlist = sceneKeyPoints.toList();
	        LinkedList<Point> objectPoints = new LinkedList<>();
	        LinkedList<Point> scenePoints = new LinkedList<>();
	        
	        for (int i = 0; i < goodMatchesList1.size(); i++) {
	            objectPoints.addLast(objKeypointlist.get(goodMatchesList1.get(i).queryIdx).pt);
	            scenePoints.addLast(scnKeypointlist.get(goodMatchesList1.get(i).trainIdx).pt);
	        }
	        
	        MatOfPoint2f objMatOfPoint2f = new MatOfPoint2f();
	        objMatOfPoint2f.fromList(objectPoints);
	        MatOfPoint2f scnMatOfPoint2f = new MatOfPoint2f();
	        scnMatOfPoint2f.fromList(scenePoints);
	        Mat homography = Calib3d.findHomography(objMatOfPoint2f, scnMatOfPoint2f, Calib3d.RANSAC, 3);
	        Mat obj_corners = new Mat(4, 1, CvType.CV_32FC2);
	        Mat scene_corners = new Mat(4, 1, CvType.CV_32FC2);
	        obj_corners.put(0, 0, new double[]{0, 0});
	        obj_corners.put(1, 0, new double[]{objectImage1.cols(), 0});
	        obj_corners.put(2, 0, new double[]{objectImage1.cols(), objectImage1.rows()});
	        obj_corners.put(3, 0, new double[]{0, objectImage1.rows()});
	        Core.perspectiveTransform(obj_corners, scene_corners, homography);
	
	        // 필요한 좌표 & 너비와 길이 저장
	        Point temp1 = new Point(scene_corners.get(0, 0));
	        Point temp2 = new Point(scene_corners.get(1, 0));
	        Point temp3 = new Point(scene_corners.get(2, 0));
	        Point storename_p1 = new Point(temp2.x, temp2.y - (int)((temp3.y-temp2.y)*0.5));
	     
	        squarePoints.add(storename_p1);
	        squareWidths.add((int)(1.5 * (temp2.x - temp1.x)));
	        squareHeights.add((int)(1.5*(temp3.y - temp2.y)));
	    } else {
	        System.out.println("로고를 찾지 못했습니다.");
	    }
	
	    // 2. [구 매]이미지를 찾았을 경우 처리
	    int listStartX = 0;
	    if (goodMatchesList2.size() >= 4) {
	        System.out.println("[구 매] 이미지를 찾았습니다.");
	        List<KeyPoint> objKeypointlist = objectKeyPoints2.toList();
	        List<KeyPoint> scnKeypointlist = sceneKeyPoints.toList();
	        LinkedList<Point> objectPoints = new LinkedList<>();
	        LinkedList<Point> scenePoints = new LinkedList<>();
	        
	        for (int i = 0; i < goodMatchesList2.size(); i++) {
	            objectPoints.addLast(objKeypointlist.get(goodMatchesList2.get(i).queryIdx).pt);
	            scenePoints.addLast(scnKeypointlist.get(goodMatchesList2.get(i).trainIdx).pt);
	        }
	        
	        MatOfPoint2f objMatOfPoint2f = new MatOfPoint2f();
	        objMatOfPoint2f.fromList(objectPoints);
	        MatOfPoint2f scnMatOfPoint2f = new MatOfPoint2f();
	        scnMatOfPoint2f.fromList(scenePoints);
	        Mat homography = Calib3d.findHomography(objMatOfPoint2f, scnMatOfPoint2f, Calib3d.RANSAC, 3);
	        Mat obj_corners = new Mat(4, 1, CvType.CV_32FC2);
	        Mat scene_corners = new Mat(4, 1, CvType.CV_32FC2);
	        obj_corners.put(0, 0, new double[]{0, 0});
	        obj_corners.put(1, 0, new double[]{objectImage2.cols(), 0});
	        obj_corners.put(2, 0, new double[]{objectImage2.cols(), objectImage2.rows()});
	        obj_corners.put(3, 0, new double[]{0, objectImage2.rows()});
	        Core.perspectiveTransform(obj_corners, scene_corners, homography);
	        
	        // 필요한 좌표 & 너비와 길이 저장
	        Point temp1 = new Point(scene_corners.get(0, 0));
	        Point temp2 = new Point(scene_corners.get(1, 0));
	        Point temp3 = new Point(scene_corners.get(2, 0));
	        Point temp4 = new Point(scene_corners.get(3, 0));
	        Point storename_p1 = new Point(temp2.x, temp2.y - (int)((temp3.y-temp2.y)*0.1));
	        listStartX = (int)temp4.x;
	     
	        squarePoints.add(storename_p1);
	        squareWidths.add((int)(2.5 * (temp2.x - temp1.x)));
	        squareHeights.add((int)(1.2 * (temp3.y - temp2.y)));
	    } else {
	        System.out.println("[구 매] 이미지를 찾지 못했습니다.");
	    }
	    
	    // 3. 단가 이미지를 찾았을 경우 처리
	    int listStartY = 0;
	    int listTemp1X = 0;
	    int listTemp2X = 0;
	    int listTemp4Y = 0;
	    if (goodMatchesList3.size() >= 4) {
	        System.out.println("단가 이미지를 찾았습니다.");
	        List<KeyPoint> objKeypointlist = objectKeyPoints3.toList();
	        List<KeyPoint> scnKeypointlist = sceneKeyPoints.toList();
	        LinkedList<Point> objectPoints = new LinkedList<>();
	        LinkedList<Point> scenePoints = new LinkedList<>();
	        
	        for (int i = 0; i < goodMatchesList3.size(); i++) {
	            objectPoints.addLast(objKeypointlist.get(goodMatchesList3.get(i).queryIdx).pt);
	            scenePoints.addLast(scnKeypointlist.get(goodMatchesList3.get(i).trainIdx).pt);
	        }
	        
	        MatOfPoint2f objMatOfPoint2f = new MatOfPoint2f();
	        objMatOfPoint2f.fromList(objectPoints);
	        MatOfPoint2f scnMatOfPoint2f = new MatOfPoint2f();
	        scnMatOfPoint2f.fromList(scenePoints);
	        Mat homography = Calib3d.findHomography(objMatOfPoint2f, scnMatOfPoint2f, Calib3d.RANSAC, 3);
	        Mat obj_corners = new Mat(4, 1, CvType.CV_32FC2);
	        Mat scene_corners = new Mat(4, 1, CvType.CV_32FC2);
	        obj_corners.put(0, 0, new double[]{0, 0});
	        obj_corners.put(1, 0, new double[]{objectImage3.cols(), 0});
	        obj_corners.put(2, 0, new double[]{objectImage3.cols(), objectImage3.rows()});
	        obj_corners.put(3, 0, new double[]{0, objectImage3.rows()});
	        Core.perspectiveTransform(obj_corners, scene_corners, homography);
	        
	        // 필요한 좌표 & 너비와 길이 저장
	        Point temp1 = new Point(scene_corners.get(0, 0));
	        Point temp2 = new Point(scene_corners.get(1, 0));
	        Point temp4 = new Point(scene_corners.get(3, 0));
	        listStartY = (int)temp4.y;
	        listTemp1X = (int)temp1.x;
	        listTemp2X = (int)temp2.x;
	        listTemp4Y = (int)temp4.y;
	    } else {
	        System.out.println("단가 이미지를 찾지 못했습니다.");
	    }
	    
	    // 4. 품목 이미지를 찾았을 경우 처리
	    int orderlistEndPointY = 0;
	    if (goodMatchesList4.size() >= 2) {
	        System.out.println("품목 이미지를 찾았습니다.");
	        List<KeyPoint> objKeypointlist = objectKeyPoints4.toList();
	        List<KeyPoint> scnKeypointlist = sceneKeyPoints.toList();
	        LinkedList<Point> objectPoints = new LinkedList<>();
	        LinkedList<Point> scenePoints = new LinkedList<>();
	        
	        for (int i = 0; i < goodMatchesList4.size(); i++) {
	            objectPoints.addLast(objKeypointlist.get(goodMatchesList4.get(i).queryIdx).pt);
	            scenePoints.addLast(scnKeypointlist.get(goodMatchesList4.get(i).trainIdx).pt);
	        }
	        
	        MatOfPoint2f objMatOfPoint2f = new MatOfPoint2f();
	        objMatOfPoint2f.fromList(objectPoints);
	        MatOfPoint2f scnMatOfPoint2f = new MatOfPoint2f();
	        scnMatOfPoint2f.fromList(scenePoints);
	        Mat homography = Calib3d.findHomography(objMatOfPoint2f, scnMatOfPoint2f, Calib3d.RANSAC, 3);
	        Mat obj_corners = new Mat(4, 1, CvType.CV_32FC2);
	        Mat scene_corners = new Mat(4, 1, CvType.CV_32FC2);
	        obj_corners.put(0, 0, new double[]{0, 0});
	        obj_corners.put(1, 0, new double[]{objectImage4.cols(), 0});
	        obj_corners.put(2, 0, new double[]{objectImage4.cols(), objectImage4.rows()});
	        obj_corners.put(3, 0, new double[]{0, objectImage4.rows()});
	        Core.perspectiveTransform(obj_corners, scene_corners, homography);
	        
	        // 필요한 좌표 & 너비와 길이 저장
	        Point temp1 = new Point(scene_corners.get(0, 0));
	        Point startOrderlist = new Point(listStartX, listTemp4Y);
	        squarePoints.add(startOrderlist);
	        squareWidths.add((int)(0.3*(listTemp2X - listTemp1X) + (listTemp1X - listStartX)));
	        squareHeights.add((int)(temp1.y - listTemp4Y));
	        orderlistEndPointY = (int)temp1.y;
	    } else {
	        System.out.println("품목 이미지를 찾지 못했습니다.");
	    }
	    
	    Point endPoint1 = new Point(
	    		(int)squarePoints.get(0).x + squareWidths.get(0), (int)squarePoints.get(0).y + squareHeights.get(0));
	    Point endPoint2 = new Point(
	    		(int)squarePoints.get(1).x + squareWidths.get(1), (int)squarePoints.get(1).y + squareHeights.get(1));
	    Point endPoint3 = new Point(
	    		(int)squarePoints.get(2).x + squareWidths.get(2), (int)squarePoints.get(2).y + squareHeights.get(2));
	    
	    Core.rectangle(img, squarePoints.get(0), endPoint1, greenColor, 4);
	    Core.rectangle(img, squarePoints.get(1), endPoint2, greenColor, 4);
	    Core.rectangle(img, squarePoints.get(2), endPoint3, greenColor, 4);
	    
	    // goodPointList의 정보대로 각 지역을 나누기
	    System.out.println("구역 분할을 수행 중입니다..");
	    for(int i=0; i<3; i++) {
	    	if(squarePoints.get(i).x < 0)
	    		squarePoints.get(i).x = 0;
	    	if(squarePoints.get(i).y < 0)
	    		squarePoints.get(i).y = 0;
	    }
	    
	    Mat square_storename 	= new Mat(sceneImage, 
	    		new Rect((int)squarePoints.get(0).x, (int)squarePoints.get(0).y, squareWidths.get(0), squareHeights.get(0)));
	    Mat square_date 		= new Mat(sceneImage, 
	    		new Rect((int)squarePoints.get(1).x, (int)squarePoints.get(1).y, squareWidths.get(1), squareHeights.get(1)));
	    Mat square_orderlist 	= new Mat(sceneImage, 
	    		new Rect((int)squarePoints.get(2).x, (int)squarePoints.get(2).y, squareWidths.get(2), squareHeights.get(2)));
	    Mat square_upperside 	= new Mat(sceneImage, 
	    		new Rect(0, 0, sceneImage.width(), orderlistEndPointY));
	    
	    // 결과 이미지를 내보냅니다.
	    Highgui.imwrite(defaultRoute + "sq_storename.jpg", square_storename);
	    Highgui.imwrite(defaultRoute + "sq_date.jpg", square_date);
	    Highgui.imwrite(defaultRoute + "sq_orderlist.jpg", square_orderlist);
	    Highgui.imwrite(defaultRoute + "sq_upperside.jpg", square_upperside);
	    Highgui.imwrite(defaultRoute + "resultImg.jpg", img);
	
	    System.out.println("구역 분할작업을 종료합니다.");
			
		///////////////////
		// google vision api
		String strArrayStorename[] = {};
		String strArrayDate[] = {};
		String strArrayOrderlist[] = {};
		String strArrayEntireScene[] = {};
		List<AnnotateImageRequest> reqStorename = new ArrayList<>();
		List<AnnotateImageRequest> reqDate = new ArrayList<>();
		List<AnnotateImageRequest> reqOrderlist = new ArrayList<>();
		List<AnnotateImageRequest> reqEntireScene = new ArrayList<>();
		ByteString imgBytes1 = ByteString.readFrom(new FileInputStream(crop_storename));
		ByteString imgBytes2 = ByteString.readFrom(new FileInputStream(crop_date));
		ByteString imgBytes3 = ByteString.readFrom(new FileInputStream(crop_orderlist));
		ByteString imgBytes4 = ByteString.readFrom(new FileInputStream(entireScene));
		Image img1 = Image.newBuilder().setContent(imgBytes1).build();
		Image img2 = Image.newBuilder().setContent(imgBytes2).build();
		Image img3 = Image.newBuilder().setContent(imgBytes3).build();
		Image img4 = Image.newBuilder().setContent(imgBytes4).build();
		Feature feat1 = Feature.newBuilder().setType(Type.TEXT_DETECTION).build();
		Feature feat2 = Feature.newBuilder().setType(Type.TEXT_DETECTION).build();
		Feature feat3 = Feature.newBuilder().setType(Type.TEXT_DETECTION).build();
		Feature feat4 = Feature.newBuilder().setType(Type.DOCUMENT_TEXT_DETECTION).build();
		// Set the Language Hint codes for handwritten OCR
		ImageContext imageContext1 = ImageContext.newBuilder().addLanguageHints("ko-t-i0-handwrit").build();
		ImageContext imageContext2 = ImageContext.newBuilder().addLanguageHints("ko-t-i0-handwrit").build();
		ImageContext imageContext3 = ImageContext.newBuilder().addLanguageHints("ko-t-i0-handwrit").build();
		ImageContext imageContext4 = ImageContext.newBuilder().addLanguageHints("ko-t-i0-handwrit").build();

		AnnotateImageRequest request1 = AnnotateImageRequest.newBuilder().addFeatures(feat1).setImage(img1)
				.setImageContext(imageContext1).build();
		AnnotateImageRequest request2 = AnnotateImageRequest.newBuilder().addFeatures(feat2).setImage(img2)
				.setImageContext(imageContext2).build();
		AnnotateImageRequest request3 = AnnotateImageRequest.newBuilder().addFeatures(feat3).setImage(img3)
				.setImageContext(imageContext3).build();
		AnnotateImageRequest request4 = AnnotateImageRequest.newBuilder().addFeatures(feat4).setImage(img4)
				.setImageContext(imageContext4).build();
		reqStorename.add(request1);
		reqDate.add(request2);
		reqOrderlist.add(request3);
		reqEntireScene.add(request4);
		
		// 문자열 읽는 데에 사용하는 변수들
		String storename = "", buydate = "";
		boolean strSwitch = false;
		List<Integer> tempList2 = new ArrayList<Integer>();	// 상품단가만 임시로 저장해둘 리스트
		List<Integer> tempList3 = new ArrayList<Integer>();	// 상품수량만 임시로 저장해둘 리스트
		List<Order> orderList = new ArrayList<Order>();		// 상품 목록 전체를 저장하는 리스트

		// 1. storename 인식
		System.out.println("지점명을 인식중입니다..");
		try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
			BatchAnnotateImagesResponse response = client.batchAnnotateImages(reqStorename);
			List<AnnotateImageResponse> responses = response.getResponsesList();
			client.close();
			for (AnnotateImageResponse res : responses) {
				if (res.hasError()) {
					System.out.printf("Error: %s\n", res.getError().getMessage());
				}

				TextAnnotation annotation = res.getFullTextAnnotation();
				for (Page page : annotation.getPagesList()) {
					String pageText = "";
					for (Block block : page.getBlocksList()) {
						String blockText = "";
						for (Paragraph para : block.getParagraphsList()) {
							String paraText = "";
							for (Word word : para.getWordsList()) {
								String wordText = "";
								for (Symbol symbol : word.getSymbolsList()) {
									wordText = wordText + symbol.getText();
								}
								paraText = String.format("%s %s", paraText, wordText);
							}
							blockText = blockText + paraText;
						}
						pageText = pageText + blockText;
					}
				}
				strArrayStorename = annotation.getText().split("\n");
			}
		}
		
		// storename의 문자열처리
		for(String str : strArrayStorename) {
			Pattern pattern1 = Pattern.compile(".*\\(0.*");
	        Matcher matcher1 = pattern1.matcher(str);
			boolean parenFound = false;
			if(matcher1.lookingAt()) {
				if(strSwitch == false) {
					int startPoint = 0, endPoint = 0;
					for(int i=0; i<str.length(); i++) {
						endPoint = str.indexOf('(');
						if(parenFound == false && endPoint != 0) {
							endPoint = i;
							parenFound = true;
						}
					}
					storename = str.substring(startPoint, endPoint);
				}
			}
		}
		
		// 2. date 인식
		System.out.println("날짜를 인식중입니다..");
		try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
			BatchAnnotateImagesResponse response = client.batchAnnotateImages(reqDate);
			List<AnnotateImageResponse> responses = response.getResponsesList();
			client.close();
			for (AnnotateImageResponse res : responses) {
				if (res.hasError()) {
					System.out.printf("Error: %s\n", res.getError().getMessage());
				}

				TextAnnotation annotation = res.getFullTextAnnotation();
				for (Page page : annotation.getPagesList()) {
					String pageText = "";
					for (Block block : page.getBlocksList()) {
						String blockText = "";
						for (Paragraph para : block.getParagraphsList()) {
							String paraText = "";
							for (Word word : para.getWordsList()) {
								String wordText = "";
								for (Symbol symbol : word.getSymbolsList()) {
									wordText = wordText + symbol.getText();
								}
								paraText = String.format("%s %s", paraText, wordText);
							}
							blockText = blockText + paraText;
						}
						pageText = pageText + blockText;
					}
				}
				strArrayDate = annotation.getText().split("\n");
			}
		}
		
		// date의 문자열처리
		for(String str : strArrayDate) {
			Pattern pattern3 = Pattern.compile(".*" + "\\d{4}\\-\\d{2}\\-\\d{2}" + ".*");
			Matcher matcher3 = pattern3.matcher(str);
			if (matcher3.lookingAt()) {
				buydate = str + ":00";
			}
		}
				
		// 3. orderlist 인식
		System.out.println("상품목록을 인식중입니다..");
		try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
			BatchAnnotateImagesResponse response = client.batchAnnotateImages(reqOrderlist);
			List<AnnotateImageResponse> responses = response.getResponsesList();
			client.close();
			for (AnnotateImageResponse res : responses) {
				if (res.hasError()) {
					System.out.printf("Error: %s\n", res.getError().getMessage());
				}

				TextAnnotation annotation = res.getFullTextAnnotation();
				for (Page page : annotation.getPagesList()) {
					String pageText = "";
					for (Block block : page.getBlocksList()) {
						String blockText = "";
						for (Paragraph para : block.getParagraphsList()) {
							String paraText = "";
							for (Word word : para.getWordsList()) {
								String wordText = "";
								for (Symbol symbol : word.getSymbolsList()) {
									wordText = wordText + symbol.getText();
								}
								paraText = String.format("%s %s", paraText, wordText);
							}
							blockText = blockText + paraText;
						}
						pageText = pageText + blockText;
					}
				}
				strArrayOrderlist = annotation.getText().split("\n");
				System.out.println(annotation.getText());
			}
		}
		
		// 4. 상품목록 인식
		System.out.println("전체이미지에서 상품목록을 인식중입니다..");
		try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
			BatchAnnotateImagesResponse response = client.batchAnnotateImages(reqEntireScene);
			List<AnnotateImageResponse> responses = response.getResponsesList();
			client.close();
			for (AnnotateImageResponse res : responses) {
				if (res.hasError()) {
					System.out.printf("Error: %s\n", res.getError().getMessage());
				}

				TextAnnotation annotation = res.getFullTextAnnotation();
				for (Page page : annotation.getPagesList()) {
					String pageText = "";
					for (Block block : page.getBlocksList()) {
						String blockText = "";
						for (Paragraph para : block.getParagraphsList()) {
							String paraText = "";
							for (Word word : para.getWordsList()) {
								String wordText = "";
								for (Symbol symbol : word.getSymbolsList()) {
									wordText = wordText + symbol.getText();
								}
								paraText = String.format("%s %s", paraText, wordText);
							}
							blockText = blockText + paraText;
						}
						pageText = pageText + blockText;
					}
				}
				strArrayEntireScene = annotation.getText().split("\n");
			}
		}

		// 상품목록 문자열 처리
		System.out.println("문자열을 처리 중입니다..");
		for(String str : strArrayEntireScene) {
			// 쉼표, ".", "|", 가운데 공백, 앞뒤공백 없애기
	        str = str.replace(" , ", "");
			str = str.replace(", ", "");
			str = str.replace(" ,", "");
			str = str.replace(",", "");
	        str = str.replace(" . ", "");
			str = str.replace(". ", "");
			str = str.replace(" .", "");
			str = str.replace(".", "");
			str = str.replace(" | ", " ");
			str = str.replace(" |", " ");
			str = str.replace("| ", " ");
			str = str.replace("|", " ");
			str = str.replace("  ", " ");
			str = str.trim();
			
	        String temp[] = str.split(" ");

			// 상품 단가와 수량 읽기
			int unitprice = 0, quantity = 0;
			
			// "금액"을 발견한 다음이고, 3개 항목 이상으로 이루어져 있고, 맨 마지막이 숫자인 경우
			if (temp.length >= 3 && isNumber(temp[temp.length - 1]) && isNumber(temp[temp.length - 2])) {
				// 맨 마지막 숫자가 100을 넘는 경우 (수량과 총액)
				if (Integer.parseInt(temp[temp.length - 1]) >= 100) {
					// 형식이 (단가, 수량, 총액)로 추정된다면 단가 부분이 숫자인지 확인하고
					if (isNumber(temp[temp.length - 3])) {
						int temp1 = Integer.parseInt(temp[temp.length - 3]);
						int temp2 = Integer.parseInt(temp[temp.length - 2]);
						int temp3 = Integer.parseInt(temp[temp.length - 1]);
						boolean checkresult = unitpriceCheck(temp1, temp2, temp3);
						// (단가, 수량, 총액)패턴으로 추정된다면
						if (checkresult) {
							unitprice = temp1;
							quantity = temp2;
						}
						// 그 외의 패턴일 경우
						else {
							// (단가, 수량, 수량, 총액)패턴으로 추정된다면
							if (temp.length >= 4 && isNumber(temp[temp.length - 4])) {
								int temp4 = Integer.parseInt(temp[temp.length - 4]);
								if (unitpriceCheck(temp4, temp2, temp3)) {
									unitprice = temp4;
									quantity = temp2;
								}
							} else {
								unitprice = 0;
								quantity = 0;
							}
						}
					}
					// 그외에는 (수량, 총액)패턴으로 인식
					else {
						if (Integer.parseInt(temp[temp.length - 1]) > 100) {
							unitprice = Integer.parseInt(temp[temp.length - 2]);
							quantity = (Integer.parseInt(temp[temp.length - 2]))
									/ (Integer.parseInt(temp[temp.length - 1]));
						} else {
							unitprice = Integer.parseInt(temp[temp.length - 2]);
							quantity = Integer.parseInt(temp[temp.length - 1]);
						}
					}
				}
				// 맨 마지막 숫자가 100을 넘지 않은 경우 (단가, 수량)패턴
				else {
					unitprice = Integer.parseInt(temp[temp.length - 2]);
					quantity = Integer.parseInt(temp[temp.length - 1]);
				}
				tempList2.add(unitprice);
				tempList3.add(quantity);
				System.out.println("unitprice : " + unitprice + ", quantity : " + quantity);
			}
			// 수량이 왼쪽이나 오른쪽 숫자에 붙어나온 경우 (ex. 1001 100 혹은 100 1100)
			else if (temp.length == 2 && isNumber(temp[temp.length - 1]) && isNumber(temp[temp.length - 2])) {
				String s_temp1 = temp[temp.length - 2];
				String s_temp2 = temp[temp.length - 1];
				int temp1 = Integer.parseInt(s_temp1); // 앞
				int temp2 = Integer.parseInt(s_temp2); // 뒤

				// (단가수량, 총액) 패턴
				if (s_temp1.length() > s_temp2.length()) {
					// 1~9개
					if (temp1 * Integer.parseInt(s_temp1.substring(s_temp1.length() - 1, s_temp1.length())) == temp2) {
						unitprice = Integer.parseInt(s_temp1.substring(0, s_temp1.length() - 1));
						quantity = Integer.parseInt(s_temp1.substring(s_temp1.length() - 1, s_temp1.length()));
					}
					// 10~99개
					else if (temp1 * Integer.parseInt(s_temp1.substring(s_temp1.length() - 2, s_temp1.length())) == temp2) {
						unitprice = Integer.parseInt(s_temp1.substring(0, s_temp1.length() - 2));
						quantity = Integer.parseInt(s_temp1.substring(s_temp1.length() - 2, s_temp1.length()));
					}
					// 그 외
					else {
						unitprice = temp1;
						quantity = temp2;
					}
				}
				// (단가, 수량총액) 패턴
				if (s_temp1.length() < s_temp2.length()) {
					// 1~9개
					if (temp1 * Integer.parseInt(s_temp2.substring(0, 1)) == temp2) {
						unitprice = temp1;
						quantity = Integer.parseInt(s_temp2.substring(0, 0));
					}
					// 10~99개
					else if (temp1 * Integer.parseInt(s_temp2.substring(0, 2)) == temp2) {
						unitprice = temp1;
						quantity = Integer.parseInt(s_temp2.substring(0, 1));
					}
					// 그 외 (1 100)
					else {
						unitprice = temp2;
						quantity = temp2 / temp1;
					}
				}
				tempList2.add(unitprice);
				tempList3.add(quantity);
				System.out.println("unitprice : " + unitprice + ", quantity : " + quantity);
			}
		} // list 반복 끝
		
		// 상품이름목록과 처리한목록 매칭시키기 (매칭 실패가 의심될 경우 단가와 수량을 0으로 변경)
		for(int i=0; i<strArrayOrderlist.length; i++) {
			int match_unitprice = 0;
			int match_quantity = 0;
			try {
				match_unitprice = tempList2.get(i);
				match_quantity = tempList3.get(i);
			} catch (Exception e) {
				//e.printStackTrace();
			}
			Order o = new Order(strArrayOrderlist[i], match_unitprice, match_quantity);
			orderList.add(o);
		}
		
		// 이미지 인식 처리결과 보기 
		System.out.println("storename : " + storename);
		System.out.println("buydate : " + buydate);
		for(Order o : orderList) {
			System.out.println(o);
		}

		System.out.println("작업이 모두 종료되었습니다.");

		HashMap<String, Object> returnData = new HashMap<String, Object>();
		buydate = buydate.substring(0, 10);
		returnData.put("storename", storename);
		returnData.put("buydate", buydate);
		returnData.put("orderlist", orderList);
		
		/* //모델에 담을 경우
		model.addAttribute("storename", storename);
		model.addAttribute("buydate", buydate);
		model.addAttribute("orderlist", orderList);
		*/
		
		return returnData;
	}
	
	@ResponseBody
	@RequestMapping("/readResultImage")
	public void readResultImage(HttpServletResponse res) throws IOException {
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		File sub = new File(defaultRoute + "resultImg.jpg");
		res.setContentType("image/jpg");
		ServletOutputStream sos = res.getOutputStream();
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(sub));
		byte[] buf = new byte[1024];
		int readByte = 0;
		while ((readByte = bis.read(buf)) != -1) {
			sos.write(buf, 0, readByte);
		}
		bis.close();
	}
	
	@ResponseBody
	@RequestMapping("/readImage")
	public void readImage(HttpServletResponse res, String imageNumber, String scheduleNo) throws IOException {
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		File sub = new File(defaultRoute + scheduleNo + "\\" + imageNumber + ".jpg");
		res.setContentType("image/jpg");
		ServletOutputStream sos = res.getOutputStream();
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(sub));
		byte[] buf = new byte[1024];
		int readByte = 0;
		while ((readByte = bis.read(buf)) != -1) {
			sos.write(buf, 0, readByte);
		}
		bis.close();
	}
	
	@ResponseBody
	@RequestMapping(value="/getNumberOfImages", method=RequestMethod.POST) 
	public int getScheduleImages(String scheduleNo) throws IOException {
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		int count = 1;
		for(int i=0; i<100; i++) {
			File myFile = new File(defaultRoute + scheduleNo + "\\" + count + ".jpg");
			if(myFile.exists()) {
				count++;
			}
			else
				break;
		}
		return count-1;
	}
	
	@ResponseBody
	@RequestMapping("/deleteUseless")
	public void deleteUseless() {
		String defaultRoute = System.getProperty("user.dir") + "\\ReciphotoResources\\images\\";
		File receiptImage 	= new File(defaultRoute + "uploadedFile.jpg");
		if(receiptImage.exists()) 	receiptImage.delete();
	}
	
	// 단가 * 수량 = 총액 체크
	public static boolean unitpriceCheck(int a, int b, int c) {
		boolean result;
		if(a * b == c) 
			result = true;
		else 
			result = false;
		return result;
	}
	
	public static boolean isNumber(String str1){
        boolean result = false;
        try {
            Double.parseDouble(str1);
            result = true;
        }
        catch(Exception e) {
        	
        }
        return result;
    }
	
	public static boolean isHangul(char c) {
		Character.UnicodeBlock unicodeBlock = Character.UnicodeBlock.of( c );
        if ( UnicodeBlock.HANGUL_SYLLABLES.equals( unicodeBlock ) || 
                UnicodeBlock.HANGUL_COMPATIBILITY_JAMO.equals( unicodeBlock )
                || UnicodeBlock.HANGUL_JAMO.equals( unicodeBlock ) )
        {
            return true;
        }
        else return false;
	}
}

class AscendingDouble implements Comparator<Double> { 
	@Override public int compare(Double a, Double b) { 
		return b.compareTo(a); 
	} 
}