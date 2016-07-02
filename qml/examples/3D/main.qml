import QtQuick 2.7
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

Rectangle {
	id: rootItem
	anchors.fill: parent
	color: "#ffffff"

	Scene3D {
		width: Math.min(parent.width, parent.height) * 0.7
		height: width
		anchors.centerIn: parent
		aspects: "input"

		Entity {
			id: sceneRoot

			Camera {
				id: camera
				projectionType: CameraLens.PerspectiveProjection
				fieldOfView: 40
				aspectRatio: 1
				nearPlane : 0.1
				farPlane : 1000.0
				position: Qt.vector3d(0.0, 0.0, 7.5)
				upVector: Qt.vector3d(0.0, 1.0, 0.0)
				viewCenter: Qt.vector3d(0.0, 0.0, 0.0)
			}

			components: [
				RenderSettings {
					activeFrameGraph:
						ForwardRenderer {
							camera: camera
							clearColor: rootItem.color
						}
				}
			]

			Entity {
				components: [
					Mesh {
						source: "qrc:/resources/meshes/logo.obj"
					},

					PhongMaterial {
						ambient: "#80c342"
						diffuse: "#161616"
						specular: "#000000"
					},

					Transform {
						rotation:fromAxesAndAngles(Qt.vector3d(1, 0, 0), xSlider.value, Qt.vector3d(0, 1, 0), ySlider.value, Qt.vector3d(0, 0, 1), zSlider.value)
					}
				]
			}
		}
	}

	GridLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: columnSpacing
		columns: 2

		Label { text: "X" }
		Slider {
			id: xSlider
			Layout.fillWidth: true
			minimumValue: 0
			maximumValue: 360
			value: 0
		}

		Label { text: "Y" }
		Slider {
			id: ySlider
			Layout.fillWidth: true
			minimumValue: 0
			maximumValue: 360
			value: 0
			enabled: !animateCheckBox.checked

			NumberAnimation on value {
				from: 0
				to: 360
				duration: 4000
				loops: NumberAnimation.Infinite
				running: animateCheckBox.checked
			}
		}

		Label { text: "Z" }
		Slider {
			id: zSlider
			Layout.fillWidth: true
			minimumValue: 0
			maximumValue: 360
			value: 0
		}

		CheckBox {
			id: animateCheckBox
			text: "Animate"
			checked: true
		}
	}
}
