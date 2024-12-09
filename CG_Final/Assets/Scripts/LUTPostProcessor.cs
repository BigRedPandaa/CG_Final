using UnityEngine;

[RequireComponent(typeof(Camera))]
public class LUTPostProcessor : MonoBehaviour
{
    public Material NoLUT;
    public Material WarmLUT;
    public Material ShadyLUT;
    public Material CustomLUT;

    private Renderer _renderer;
    private int _currentLUTIndex = 0;


    void Start()
    {
        _renderer = GetComponent<Renderer>();
        SetLUT();
    }

    void Update()
    {
      
    }

    void SetLUT()
    {
        switch (_currentLUTIndex)
        {
            case 0:
                _renderer.material = NoLUT;
                break;
            case 1:
                _renderer.material = WarmLUT;
                break;
            case 2:
                _renderer.material = ShadyLUT;
                break;
            case 3:
                _renderer.material = CustomLUT;
                break;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_renderer.material != null)
        {
            // Set the LUT size
            _renderer.material.SetFloat("_LUTSize", 24); // or your LUT size
            // Apply the LUT texture
            Graphics.Blit(source, destination, _renderer.material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}