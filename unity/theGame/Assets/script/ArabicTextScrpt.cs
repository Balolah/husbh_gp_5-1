using System.Collections; 
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using ArabicSupport;


public class ArabicTextScrpt : MonoBehaviour
{

      [TextArea]
      public string text;

    public Text arabicText; 
    // Start is called before the first frame update
    void Start()
    {
        arabicText.text =  ArabicFixer.Fix(text);
        
    }
}