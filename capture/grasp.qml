import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
import QtQml 2.0
import QtQuick.Dialogs 1.2
Item{
   height:Screen.desktopAvailableHeight
   width:Screen.desktopAvailableWidth
   property  point curpos:"0,0"
   property point holdpos:"0,0"
   property point movepos:"0,0"
   property bool isStart:false
   property bool isMoving:false
   property point cornerpos:"0,0"
   property bool cornerstart: false
   property variant rets:[{"sid":"lt"},{"sid":"lb"},{"sid":"rt"},{"sid":"rb"}]
   Rectangle{
       id:mainrec
       focus:true
       anchors.fill: parent
       opacity: 0.8
       color:"#fff"
       Keys.enabled: true
       Keys.onEscapePressed: {
              graspwin.closeGraspwin()
           }
   MouseArea{
     anchors.fill: parent
     hoverEnabled:true
     id:mainmousearea
     onEntered: {
         curpos = Qt.point(mainmousearea.mouseX,mainmousearea.mouseY)
         setShowRec(curpos)

     }
     onMouseXChanged: {
            curpos = Qt.point(mainmousearea.mouseX,curpos.y)
         setShowRec(curpos)
     }
     onMouseYChanged: {
        curpos = Qt.point(curpos.x,mainmousearea.mouseY)
        setShowRec(curpos)
     }
     onPressAndHold: {

     }

   }
   Rectangle{
       id:showrec
       width:100
       height:140
       color: "#666"
       opacity: 1
       border.color: "#999"
       border.width: 1
       Keys.enabled: true
       Canvas{
           id:scanvas
           width:100
           height:100
           anchors.left: parent.left
           anchors.top: parent.top
           antialiasing: true
            onPaint: {
                      if(imgP.source!=""){
                          scanvas.getContext('2d').clearRect(0,0,100,100)
                          scanvas.getContext('2d').drawImage(imgP,curpos.x-25,curpos.y-25,50,50,0,0,100,100)


                     }

           }
       }
       Image{
           source: "../images/toolWidget/96.png"
           height:100
           width: 100
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top:parent.top
           z:2
       }
       Text{
           id:showcpo
           height:20
           width:100
           anchors.top:scanvas.bottom
           anchors.left:parent.left
           text:curpos.x +"," + curpos.y
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           color: "#fff"
           styleColor: "#000"
           style: Text.Outline
       }
       Rectangle{
           id:showclorec
           height:20
           width:100
           anchors.top:showcpo.bottom
           anchors.left:parent.left
           color:"#666"
       Text{
           id:showclo
           anchors.fill: parent
           text:curpos.x +"," + curpos.y
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           color: "#fff"
           styleColor: "#000"
           style: Text.Outline

       }
       }
   }

   Image{
           id:imgP
           source:"123.png"
           visible: false
       }
   Rectangle{
       opacity: 1
       id:arearec
       width:1
       height:1
       x:curpos.x
       y:curpos.y
       z:5
       border.color:"green"
       Keys.enabled: true
       Canvas{
           id:bcanvas
           anchors.fill: parent
           height:parent.height
           width:parent.width
           antialiasing: true
           onImageLoaded: {
                       if(scanvas.isImageLoaded(imgP.source))
                       {
                           console.log("imps")
                       }
                       if(scanvas.isImageError(imgP.source))
                       {
                           console.log("impE")
                       }
                   }
           onPaint: {
                      if(imgP.source!=""){
                          if(arearec.x<0) arearec.x =0
                          if(arearec.y<0) arearec.y = 0
                          bcanvas.getContext('2d').clearRect(0,0,bcanvas.width,bcanvas.height)
                          bcanvas.getContext('2d').drawImage(imgP,arearec.x,arearec.y,arearec.width,arearec.height,0,0,bcanvas.width,bcanvas.height)
                      }

           }
       }
       MouseArea{
          id:areamousearea
          anchors.fill: parent
          onPressed:  {
              holdpos = Qt.point(mainmousearea.mouseX,mainmousearea.mouseY)
              if(arearec.width<3 && arearec.height<3){
                  isStart = true
              }

              movepos =Qt.point(mouse.x,mouse.y)
          }
          onReleased: {
             var thispos = Qt.point(mainmousearea.mouseX,mainmousearea.mouseY)
              if(thispos == holdpos){
                isStart = false
              }
              isMoving = false
          }
          onPositionChanged: {
                cursorShape = Qt.SizeAllCursor
                curpos = Qt.point(mainmousearea.mouseX,mainmousearea.mouseY)
              if(isStart){
              arearec.width = mouse.x
              arearec.height = mouse.y
              arearec.x = holdpos.x
              arearec.y = holdpos.y
              setShowRec(curpos)
                  if(arearec.width>11 && arearec.height > 11){
                      setCorner()
                  }
              }else{
                  isMoving = true
                var delta = Qt.point(mouse.x-movepos.x, mouse.y-movepos.y)
                  arearec.x = arearec.x +delta.x
                  arearec.y = arearec.y+delta.y
                  var recdelta = Qt.point(arearec.x+arearec.width,arearec.y+arearec.height)
                  if(arearec.width>11 && arearec.height > 11){
                  setShowRec(Qt.point(arearec.x + arearec.width,arearec.y + arearec.height))
                  setCorner()
                  }
              }
                     bcanvas.requestPaint()
          }
          onDoubleClicked: {
              checkFileName("",false)
          }

       }

   }

   Rectangle{
       id:correc
       anchors.fill: parent
       color:"#00000000"
       Keys.enabled: false
   Repeater {
       id:repeater
       model: rets
   Rectangle{
       objectName: modelData.sid
       width:9
       height:9
       border.color:"blue"
       visible: false
       radius: 5
       MouseArea{
           anchors.fill:parent
           id:brarea
           hoverEnabled: true
           onEntered: {
               if(parent.objectName=="lt" || parent.objectName =="rb"){
                   cursorShape = Qt.SizeFDiagCursor
               }else if(parent.objectName=="lb" || parent.objectName =="rt"){
                   cursorShape = Qt.SizeBDiagCursor
               }

           }
           onExited: {
               cursorShape = Qt.ArrowCursor
           }

           onPressed: {
               cornerpos = Qt.point(mouse.x,mouse.y)
               cornerstart = true
           }
           onReleased: {
               cornerstart = false
           }onPositionChanged: {
             if(cornerstart){
                 if(arearec.width<15 || arearec.height < 15){
                    if(arearec.width<15) arearec.width=15
                    if(arearec.height < 15)arearec.height = 15

                     }
                 else{
                     isMoving = true
                var offset = Qt.point(mouse.x-cornerpos.x,mouse.y-cornerpos.y)
                doRecChange(offset,parent.objectName)
                 }
                 setCorner()
                setShowRec(Qt.point(arearec.x + arearec.width,arearec.y + arearec.height))
             }
                    bcanvas.requestPaint()
           }
       }
   }
}

}
  Keys.onPressed:{
                if(event.key==Qt.Key_S && Qt.ControlModifier)
                {
                    if(arearec.width>10 && arearec.height>10)
                    fileDialog.visible = true
                }
   }
}
   Text{
    color:"#fff"
    font.pixelSize: 24
    font.family: "微软雅黑"
    font.bold: true
    text:"Ctrl+S保存截图，双击存入剪贴板,ESC取消并退出"
    style:Text.Outline
    styleColor: "#000"
    x:20
    y:20
   }
   FileDialog {
       id: fileDialog
       title: "图片另存为"
       visible: false
       nameFilters: [ "Image files (*.png *.jpeg )" ]
       selectExisting:false
       selectMultiple :false
       onAccepted: {
           checkFileName(fileDialog.fileUrl,true)
       }
       onRejected: {
           console.log("Canceled")

       }
   }
   function setShowRec(cpo){
       var hall = Screen.desktopAvailableHeight
       var wall = Screen.desktopAvailableWidth
       var mts;
       if(isStart || cornerstart || isMoving ||(!isStart &&!cornerstart && arearec.height==1))
      {
           showrec.visible = true
           showrec.z = 4
           if(!isStart &&!cornerstart && arearec.height==1)
           {
           showrec.x =cpo.x+10
           showrec.y =cpo.y+10
           if(wall - showrec.x < 110){
               showrec.x = cpo.x-110
           }
           if(hall - showrec.y <160){
               showrec.y = cpo.y-160
           }
           mts = graspwin.getThisColor("("+cpo.x+","+cpo.y+")")
           }else if(isStart || cornerstart || isMoving)
           {
                showrec.x = arearec.x + arearec.width + 20
                showrec.y = arearec.y + arearec.height +20
               if(hall - arearec.height-arearec.y <  160 ){
                   showrec.y = arearec.y + arearec.height -160

                }
               if( wall- arearec.width - arearec.x  <  120){
               showrec.x = arearec.x + arearec.width -120
               }

               curpos = Qt.point(arearec.x + arearec.width,arearec.y + arearec.height)
               mts = graspwin.getThisColor("("+curpos.x+","+curpos.y+")")

           }
           scanvas.requestPaint()
           showclo.text = mts.split("|")[0]
           showclorec.color = "#"+mts.split("|")[1]
       }
       else{
          showrec.visible = false
          showrec.z = 1
       }
   }
   function setCorner(){
       var ttt = correc.children
       for(var j in rets){
                for(var i in ttt){
                   if(ttt[i]["objectName"] == rets[j].sid){
                       ttt[i].visible = true
                       if(rets[j].sid=="lt"){
                           ttt[i].x=arearec.x-5
                           ttt[i].y=arearec.y-5
                       }
                       if(rets[j].sid=="lb"){
                           ttt[i].x=arearec.x-5
                           ttt[i].y=arearec.y + arearec.height -5
                       }
                       if(rets[j].sid=="rt"){
                           ttt[i].x=arearec.x + arearec.width -5
                           ttt[i].y=arearec.y -5
                       }
                       if(rets[j].sid=="rb"){
                           ttt[i].x=arearec.x + arearec.width -5
                           ttt[i].y=arearec.y + arearec.height -5
                       }
                   }
               }
           }
   }
function doRecChange(po,obj){
 if(arearec.width>10 && arearec.height > 10 && cornerstart){
       switch(obj){
          case "lt":
                  arearec.x +=  po.x
                  arearec.width -= po.x
                  arearec.y +=  po.y
                  arearec.height -= po.y
             break;
          case "lb":
                   arearec.x +=  po.x
                  arearec.width -= po.x
                   arearec.height += po.y
              break;
          case "rt":
                   arearec.y +=  po.y
                   arearec.width += po.x
                   arearec.height -= po.y
              break;
          case "rb":
               arearec.width += po.x
               arearec.height += po.y
              break;
          default:
              break;
       }
 }else{
     console.log("too small size to resize, the width = " +arearec.width +"  and the height = "+ arearec.height )
     return false;
   }
}
   function checkFileName(fn,b){
       //b 是否存储本地
       var fext=''
       if(!b){
           fext = "png"
           var ss = bcanvas.toDataURL("image/"+fext)
            graspwin.saveGrasp(ss,"zero",fext)
       }
       else{
       var furls = fn.toString()
       if(furls.match(/^file:\/\/\/[\w\W]+/)){
           furls = furls.substring(8)
       }
       var fname = furls.substring(furls.lastIndexOf('/')+1,furls.length)
        if(fname.match(/^[\w]+[\w\.\-\_]*\.(jpg|png|JPG|PNG|JPEG|jpeg)$/))
       {
          fext = fname.substring(fname.lastIndexOf('.')+1,fname.length)
          
           //var cc = bcanvas.save(furls,fext)
          var sss = bcanvas.toDataURL("image/"+(fext=="png"?"png":"jpeg"))
           graspwin.saveGrasp(sss,furls,fext)
       }else{
           //文件名错误
           console.log("wrong name : " + fname)
       }
        console.log("文件名 =" + fname + "        路径 = "+ furls + "      类型 = " + fext )
   }
}
}