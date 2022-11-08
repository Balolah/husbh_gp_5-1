using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToSubGame : MonoBehaviour
{
    public GameObject canvas;
    public GameObject gamepage;
    
   public GameObject[] panals;

   public void page2(){

    gamepage.SetActive(false);//  turn off Game page display the game 
    canvas.SetActive(true);//  Turn on display the game 
    

   }

   
}