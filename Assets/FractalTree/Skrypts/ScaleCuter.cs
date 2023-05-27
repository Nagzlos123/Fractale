using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleCuter : MonoBehaviour
{
    public float scaler = 0.5f;

    public void Generated(int index)
    {
        this.transform.localScale *= scaler;
    }
}
