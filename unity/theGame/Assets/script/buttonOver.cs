using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class buttonOver : MonoBehaviour
{     [SerializeField]
private Transform targetTransform;
    // Start is called before the first frame update
    private RectTransform rectTransform;
    private Image image;
    private void Awake() {
        { 
            rectTransform = GetComponent<RectTransform>();
              image = GetComponent<Image>();

        }
    }

    // Update is called once per frame
     private void Update()
    {
         var screenPoint = Camera.main.WorldToScreenPoint(targetTransform.position);
         rectTransform.position = screenPoint;
          var viewportPoint =Camera.main.WorldToViewportPoint(targetTransform.position);
          var distanceFormCenter =Vector2.Distance(viewportPoint,Vector2.one * 0.5f);
           var show =distanceFormCenter<0.3f;
           GetComponent<Image>().enabled=show;

    }
}
