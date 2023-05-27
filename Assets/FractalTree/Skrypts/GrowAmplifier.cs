using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrowAmplifier : MonoBehaviour
{
    public void Generated()
    {
        this.gameObject.transform.position += this.transform.up * this.transform.localScale.y;
    }
}
