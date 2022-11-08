using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

[RequireComponent (typeof(ARPlaneManager))]
public class ARPlacement : MonoBehaviour
{


   public GameObject welcomePanel;
   public GameObject placedObject;
   public GameObject placedPrefab;
   public Button disimssButton;
//    public Camera arCamera;
   public ARPlaneManager aRPlaneManager;

   void Awak(){
    disimssButton.onClick.AddListener(Dissmiss);
    aRPlaneManager = GetComponent<ARPlaneManager>();
    aRPlaneManager.planesChanged += PlaneChanged;
   }
   public void PlaneChanged(ARPlanesChangedEventArgs args){
    if(args.added !=null && placedObject == null){
        ARPlane aRPlane = args.added[0];
        placedObject = Instantiate(placedPrefab , aRPlane.transform.position, Quaternion.identity);
    }
   }
   private void Dissmiss() => welcomePanel.SetActive(false);

   
//    public PlacementObject placedObject;
//    public Button disissButton;
//    public Camera arCamera;

    // public GameObject arObjectToSpawn;
    // public GameObject placementIndicator;
    // private GameObject spawnedObject;
    // private Pose PlacementPose;
    // private ARRaycastManager aRRaycastManager;
    // private bool placementPoseIsValid = false;
    

    // void Start()
    // {
    //     aRRaycastManager = FindObjectOfType<ARRaycastManager>();
    // }

    // // need to update placement indicator, placement pose and spawn 
    // void Update()
    // {
    //     if(spawnedObject == null && placementPoseIsValid && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
    //     {
    //         ARPlaceObject();
    //     }


    //     UpdatePlacementPose();
    //     UpdatePlacementIndicator();


    // }
    // void UpdatePlacementIndicator()
    // {
    //     if(spawnedObject == null && placementPoseIsValid)
    //     {
    //         placementIndicator.SetActive(true);
    //         placementIndicator.transform.SetPositionAndRotation(PlacementPose.position, PlacementPose.rotation);
    //     }
    //     else
    //     {
    //         placementIndicator.SetActive(false);
    //     }
    // }

    // void UpdatePlacementPose()
    // {
    //     var screenCenter = Camera.current.ViewportToScreenPoint(new Vector3(-0.5f,-0.5f));
    //     var hits = new List<ARRaycastHit>();
    //     aRRaycastManager.Raycast(screenCenter, hits, TrackableType.Planes);

    //     placementPoseIsValid = hits.Count > 0;
    //     if(placementPoseIsValid)
    //     {
    //         PlacementPose = hits[0].pose;
    //     }
    // }

    // void ARPlaceObject()
    // {
    //     spawnedObject = Instantiate(arObjectToSpawn, PlacementPose.position, PlacementPose.rotation);
    // }




}
