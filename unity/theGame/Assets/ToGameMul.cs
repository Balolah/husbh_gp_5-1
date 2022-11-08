using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToGameMul : MonoBehaviour
{
    public GameObject canvas;
    public GameObject gamepage;
    // Start is called before the first frame update
   public GameObject[] panals;

   public void gamePage(){

    gamepage.SetActive(true);
    canvas.SetActive(false);
    

   }

   
}

