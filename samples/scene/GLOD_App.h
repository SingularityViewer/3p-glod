/******************************************************************************
 * Copyright 2003 Jonathan Cohen, Nat Duca, David Luebke, Brenden Schubert    *
 *                Johns Hopkins University and University of Virginia         *
 ******************************************************************************
 * This file is distributed as part of the GLOD library, and as such, falls   *
 * under the terms of the GLOD public license. GLOD is distributed without    *
 * any warranty, implied or otherwise. See the GLOD license for more details. *
 *                                                                            *
 * You should have recieved a copy of the GLOD Open-Source License with this  *
 * copy of GLOD; if not, please visit the GLOD web page,                      *
 * http://www.cs.jhu.edu/~graphics/GLOD/license for more information          *
 ******************************************************************************/
/***************************************************************************
 * GLOD App -- Headers
 ****************************************************************************/
#ifndef GLOD_APP_H
typedef struct {
  PlyModel plymodel;

  int glod_id;
} Model;

typedef struct {
  Model* model;
  int glod_name;
  int glod_group;

  float pos[3];
  float rot[4];
} Object;
#endif
