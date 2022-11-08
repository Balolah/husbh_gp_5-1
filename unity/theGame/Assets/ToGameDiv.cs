using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToGameDiv : MonoBehaviour
{
    public GameObject canvas;
    public GameObject gamepage;
    // Start is called before the first frame update
   public GameObject[] panals;

   public void gamePage(){

    gamepage.SetActive(true);//display Game page 
    canvas.SetActive(false);// turn off operation game 
    

   }

   
}
