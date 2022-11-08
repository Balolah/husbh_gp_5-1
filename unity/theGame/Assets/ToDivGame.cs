using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToDivGame : MonoBehaviour
{
    public GameObject canvas;
    public GameObject gamepage;
    // Start is called before the first frame update
   public GameObject[] panals;

   public void page2(){

    gamepage.SetActive(false);
    canvas.SetActive(true);
    

   }

   
}

