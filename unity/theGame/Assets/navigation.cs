using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class navigation : MonoBehaviour
{
public GameObject canvas;
public GameObject panel2;

public void page2(){
    panel2.SetActive(false);
    canvas.SetActive(true);
}
}
