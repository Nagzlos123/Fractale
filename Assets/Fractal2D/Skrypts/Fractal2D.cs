using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Fractal2D : MonoBehaviour
{
    double width, height;
    double rStart, iStart;
    int maxIterations, increment;
    float zoom;

    public ComputeShader shader;
    ComputeBuffer buffer;
    RenderTexture texture;
    public RawImage image;

    public struct DataStruct
    {
        public double w, r, i;
        public double h;
        public int screenWidth, screenHeight;
    }

    DataStruct[] data;

    // Start is called before the first frame update
    void Start()
    {
        InitFractalVariabules();

        buffer = new ComputeBuffer(1, 40);

        texture = new RenderTexture(Screen.width, Screen.height, 0);
        texture.enableRandomWrite = true;
        texture.Create();

        Metabrot();
    }

    // Update is called once per frame
    void Update()
    {

    }
    void Metabrot()
    {
        int kernelHandle = shader.FindKernel("CSMain");
        shader.SetBuffer(kernelHandle, "buffer", buffer);
        shader.SetInt("maxIterations", maxIterations);
        shader.SetTexture(kernelHandle,"Result", texture);
        shader.Dispatch(kernelHandle, Screen.width / 20, Screen.height / 20, 1);

        RenderTexture.active = texture;
        image.material.mainTexture = texture;
    }

    void InitFractalVariabules()
    {
        width = 4.5;
        height = width * Screen.height / Screen.width;
        rStart = -2.0;
        iStart = -1.25;
        maxIterations = 500;
        increment = 3;
        zoom = 0.5f;

        data = new DataStruct[1];
        data[0] = new DataStruct
        {
            w = width,
            h = height,
            r = rStart,
            i = iStart,
            screenWidth = Screen.width,
            screenHeight = Screen.height
        };

    }
    private void OnDestroy()
    {
        buffer.Dispose();
    }
}

