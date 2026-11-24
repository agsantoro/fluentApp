trafficLight = function (stateLight) {
  
  red_class <- if (stateLight == "red") "active" else ""
  yellow_class <- if (stateLight == "yellow") "active" else ""
  green_class <- if (stateLight == "green") "active" else ""
  
  div(
    tags$style(HTML("
    .traffic-light {
      display: flex;
      flex-direction: column;
      align-items: center;
      width: 45px;
      height: 110px;
      padding: 6px;
      background: linear-gradient(145deg, rgba(248, 249, 250, 0.7), rgba(233, 236, 239, 0.7));
      border: 1px solid #dee2e6;
      border-radius: 6px;
      margin: 7.5px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      position: relative;
    }
    
    .traffic-light::before {
      content: '';
      position: absolute;
      top: -1px;
      left: 50%;
      transform: translateX(-50%);
      width: 6px;
      height: 4px;
      background: #6c757d;
      border-radius: 0 0 2px 2px;
    }
    
    .light {
      width: 25px;
      height: 25px;
      border-radius: 50%;
      background: #f1f3f4;
      margin: 4px 0;
      border: 1px solid #e1e5e9;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }
    
    .light::before {
      content: '';
      position: absolute;
      top: 20%;
      left: 20%;
      width: 30%;
      height: 30%;
      background: rgba(255,255,255,0.3);
      border-radius: 50%;
      transition: opacity 0.3s ease;
      opacity: 0;
    }
    
    .light.red.active {
      background: radial-gradient(circle at 30% 30%, #dc3545, #b02a37);
      border-color: #b02a37;
      box-shadow: 0 0 8px rgba(220,53,69,0.4), inset 0 1px 2px rgba(255,255,255,0.2);
    }
    
    .light.yellow.active {
      background: radial-gradient(circle at 30% 30%, #ffc107, #d39e00);
      border-color: #d39e00;
      box-shadow: 0 0 8px rgba(255,193,7,0.4), inset 0 1px 2px rgba(255,255,255,0.2);
    }
    
    .light.green.active {
      background: radial-gradient(circle at 30% 30%, #28a745, #1e7e34);
      border-color: #1e7e34;
      box-shadow: 0 0 8px rgba(40,167,69,0.4), inset 0 1px 2px rgba(255,255,255,0.2);
    }
    
    .light.active::before {
      opacity: 1;
    }
    
    .light:not(.active) {
      background: #e9ecef;
      border-color: #ced4da;
    }
    
    @media (max-width: 768px) {
      .traffic-light {
        width: 35px;
        height: 90px;
        padding: 4px;
      }
      .light {
        width: 20px;
        height: 20px;
        margin: 3px 0;
      }
    }
  ")),
    div(class = "traffic-light",
        div(class = paste("light red", red_class)),
        div(class = paste("light yellow", yellow_class)),
        div(class = paste("light green", green_class))
    )  
  )
}